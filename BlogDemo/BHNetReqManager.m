//
//  BHNetReqManager.m
//  BlogDemo
//
//  Created by HanBin on 16/1/26.
//  Copyright © 2016年 BinHan. All rights reserved.
//
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "BHCustomURLCache.h"

#ifdef DEBUG
    #define SERVERS_PREFIX   @"test_prefix"
#else
    #define SERVERS_PREFIX   @"product_prefix"
#endif

#define consumerKey @"iOS"

@interface BHNetReqManager()

@property (nonatomic, copy) NSString *requestUrl;
@property (nonatomic, assign)  RequestType requestType;
@property (nonatomic, assign)  RequestSerializer requestSerializer;
@property (nonatomic, assign)  ResponseSerializer responseSerializer;
@property (nonatomic, copy)  id parameters;

@end

@implementation BHNetReqManager

- (BHNetReqManager* (^)(NSString *url))bh_requestUrl
{
    return ^BHNetReqManager* (NSString *url) {
        self.requestUrl = url;
        return self;
    };
}

- (BHNetReqManager* (^)(RequestType requestType))bh_requestType
{
    return ^BHNetReqManager* (RequestType requestType) {
        self.requestType = requestType;
        return self;
    };
}

- (BHNetReqManager* (^)(RequestSerializer serializer))bh_requestSerializer
{
    return ^BHNetReqManager* (RequestSerializer serializer) {
        self.requestSerializer = serializer;
        return self;
    };
}

- (BHNetReqManager* (^)(ResponseSerializer serializer))bh_responseSerializer
{
    return ^BHNetReqManager* (ResponseSerializer serializer) {
        self.responseSerializer = serializer;
        return self;
    };
}

- (BHNetReqManager* (^)(id parameters))bh_parameters
{
    return ^BHNetReqManager *(id parameters) {
        self.parameters = parameters;
        return self;
    };
}

/**
 *  获取BHNetReqManager单例并进行初始化设置
 *
 *  @return 返回BHNetReqManager
 */
+(instancetype)sharedManager
{
    static BHNetReqManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[BHNetReqManager alloc] init];
        [sharedManager resetConfigWithManager];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        BHCustomURLCache *sharedCache = [BHCustomURLCache standardURLCache];
        [NSURLCache setSharedURLCache:sharedCache];
    });
    return sharedManager;
}

+ (NetworkStates)getNetworkStates
{
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    NetworkStates states = NetworkStatesNone;
    for (id child in subviews)
    {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")])
        {
            int networkType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            switch (networkType)
            {
                case 0:
                    states = NetworkStatesNone;
                    break;
                case 1:
                    states = NetworkStates2G;
                    break;
                case 2:
                    states = NetworkStates3G;
                    break;
                case 3:
                    states = NetworkStates4G;
                    break;
                case 5:
                {
                    states = NetworkStatesWIFI;
                }
                    break;
                default:
                    break;
            }
        }
    }
    return states;
}


/**
 *  请求方法/consumerKey/请求参数一起参数的加密运算，用于获取mac值
 *
 *  @param query  请求地址
 *  @param params 请求参数
 *
 *  @return 返回加密后的值，可与服务器端协商加密算法
 */
- (NSString *)sign
{
    NSString *sign = @"signTest";
    return sign;
}

-(AFHTTPSessionManager *)setupRequestSerializerWithManager:(AFHTTPSessionManager *)manager
{
    switch (self.requestSerializer)
    {
        case HTTPRequestSerializer:
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        case JSONRequestSerializer:
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        case PropertyListRequestSerializer:
            manager.requestSerializer = [AFPropertyListRequestSerializer serializer];
            break;
        default:
            break;
    }
    return manager;
}

-(AFHTTPSessionManager *)setupResponseSerializerWithManager:(AFHTTPSessionManager *)manager
{
    switch (self.responseSerializer) {
        case HTTPResponseSerializer:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        case JSONResponseSerializer:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case XMLParserResponseSerializer:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        default:
            break;
    }
    return manager;
}

/**
 *  对请求头、设置
 *
 *  @return 返回AFHTTPSessionManager对象
 */
-(AFHTTPSessionManager *)setupAFHTTPSessionManager
{
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SERVERS_PREFIX]];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.requestSerializer.timeoutInterval = 10.f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"channel"];
    [manager.requestSerializer setValue:consumerKey forHTTPHeaderField:@"consumerKey"];
    [manager.requestSerializer setValue:[self sign] forHTTPHeaderField:@"sign"];
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock: ^(AFNetworkReachabilityStatus status) {
        switch (status)
        {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [operationQueue setSuspended:YES];
                break;
            default:
                break;
        }
    }];
    [manager.reachabilityManager startMonitoring];
    return manager;
}

-(void)startRequestWithCompleteHandler:(void (^)(id response, NSError *error))handler
{
    AFHTTPSessionManager *manager = [self setupAFHTTPSessionManager];

    [self setupRequestSerializerWithManager:manager];
    [self setupResponseSerializerWithManager:manager];
    switch (self.requestType)
    {
        case GET:
        {
            [manager GET:self.requestUrl parameters:self.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                handler(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                handler(nil, error);
            }];
            break;
        }
        case POST:
        {
            [manager POST:self.requestUrl parameters:self.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 handler(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                handler(nil, error);
            }];
            break;
        }
        case PUT:
        {
            [manager PUT:self.requestUrl parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                handler(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                handler(nil, error);
            }];
            break;
        }
        case DELETE:
        {
            [manager DELETE:self.requestUrl parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                handler(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                handler(nil, error);
            }];
            break;
        }
        case PATCH:
        {
            [manager PATCH:self.requestUrl parameters:self.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                handler(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                handler(nil, error);
            }];
            break;
        }
        default:
            break;
    }
    [self resetConfigWithManager];
    //            注释掉的是缓存代码
    //            NSURLSessionDataTask *task =  [manager GET:self.requestUrl parameters:self.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //                handler(responseObject, nil);
    //                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
    //                NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:task.response data:data];
    //                [[BHCustomURLCache standardURLCache] storeCachedResponse:cachedResponse forRequest:task.originalRequest];
    //            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //                handler(nil, error);
    //            }];
    //            NSCachedURLResponse *reaponse = [[BHCustomURLCache standardURLCache] cachedResponseForRequest:task.originalRequest];
    //            if (reaponse)
    //            {
    //                handler(reaponse.data, nil);
    //                [task cancel];
    //            }
}

/**
 *  恢复默认设置
 */
-(void)resetConfigWithManager
{
    self.requestUrl = nil;
    self.requestType = GET;
    self.requestSerializer = HTTPRequestSerializer;
    self.responseSerializer = JSONResponseSerializer;
    self.parameters = nil;
}

@end
