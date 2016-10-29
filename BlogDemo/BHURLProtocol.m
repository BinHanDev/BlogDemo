//
//  BHURLProtocol.m
//  BlogDemo
//
//  Created by HanBin on 2016/4/29.
//  Copyright © 2016年 BinHan. All rights reserved.
//

NSString * const URLProtocolHandledKey = @"URLProtocolHandledKey";

#import "BHURLProtocol.h"

@interface BHURLProtocol() <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation BHURLProtocol

/**
 这个方法主要是说明你是否打算处理对应的request，如果不打算处理，返回NO，URL Loading System会使用系统默认的行为去处理；
 如果打算处理，返回YES，然后你就需要处理该请求的所有东西，包括获取请求数据并返回给 URL Loading System。
 */
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    //看看是否已经处理过了，防止无限循环
    if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request])
    {
        return NO;
    }
    //只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame || [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame))
    {
        return YES;
    }
    return NO;
}

/**
 通常该方法你可以简单的直接返回request，但也可以在这里修改request，比如添加header，修改host等，
 并返回一个新的request，这是一个抽象方法，子类必须实现。
 */
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
//    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
//    mutableReqeust = [self redirectHostInRequset:mutableReqeust];
//    return mutableReqeust;
    return request;
}

+(NSMutableURLRequest*)redirectHostInRequset:(NSMutableURLRequest*)request
{
    if ([request.URL host].length == 0)
    {
        return request;
    }
    NSString *originUrlString = [request.URL absoluteString];
    NSString *originHostString = [request.URL host];
    NSRange hostRange = [originUrlString rangeOfString:originHostString];
    if (hostRange.location == NSNotFound) return request;
    NSString *ip = @"cn.bing.com";
    NSString *urlString = [originUrlString stringByReplacingCharactersInRange:hostRange withString:ip];
    NSURL *url = [NSURL URLWithString:urlString];
    request.URL = url;
    return request;
}

/**
 主要判断两个request是否相同，如果相同的话可以使用缓存数据，通常只需要调用父类的实现。
 */
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

/**
 *  开始加载，在该方法中，加载一个请求
 */
- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //标示改request已经处理过了，防止无限循环
    [NSURLProtocol setProperty:@(YES) forKey:URLProtocolHandledKey inRequest:mutableReqeust];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]] ;
    NSURLSessionDataTask * task = [self.session dataTaskWithRequest:mutableReqeust];
    [task resume];
}

/**
 *  取消请求
 */
- (void)stopLoading
{
    [self.session invalidateAndCancel];
    self.session = nil;
}

#pragma mark - NSURLSessionDataDelegate

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error)
    {
        [self.client URLProtocol:self didFailWithError:error];
    }
    else
    {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    //默认情况下，当接收到服务器响应之后，服务器认为客户端不需要接收数据，所以后面的代理方法不会调用
    //如果需要继续接收服务器返回的数据，那么需要调用block,并传入对应的策略
    /*
     NSURLSessionResponseCancel = 0, 取消任务
     NSURLSessionResponseAllow = 1,  接收任务
     NSURLSessionResponseBecomeDownload = 2, 转变成下载
     NSURLSessionResponseBecomeStream NS_ENUM_AVAILABLE(10_11, 9_0) = 3, 转变成流
     */
    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask  willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler
{
    completionHandler(proposedResponse);
}


@end
