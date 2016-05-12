//
//  BHCustomURLCache.m
//  BlogDemo
//
//  Created by HanBin on 16/4/28.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHCustomURLCache.h"

static NSString * const CustomURLCacheExpirationKey = @"CustomURLCacheExpiration";
static NSTimeInterval const CustomURLCacheExpirationInterval = 600;

@interface BHCustomURLCache()

@end

@implementation BHCustomURLCache

+ (instancetype)standardURLCache {
    static BHCustomURLCache *_standardURLCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _standardURLCache = [[BHCustomURLCache alloc] initWithMemoryCapacity:(2 * 1024 * 1024) diskCapacity:(100 * 1024 * 1024) diskPath:nil];
    });
    return _standardURLCache;
}
                  
#pragma mark - NSURLCache
                  
- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request
{
    NSCachedURLResponse *cachedResponse = [super cachedResponseForRequest:request];
    if (cachedResponse)
    {
      NSDate* cacheDate = cachedResponse.userInfo[CustomURLCacheExpirationKey];
      NSDate* cacheExpirationDate = [cacheDate dateByAddingTimeInterval:CustomURLCacheExpirationInterval];
      if ([cacheExpirationDate compare:[NSDate date]] == NSOrderedAscending)
      {
          [self removeCachedResponseForRequest:request];
          return nil;
      }
    }
    return cachedResponse;
}


- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:cachedResponse.userInfo];
    userInfo[CustomURLCacheExpirationKey] = [NSDate date];
    
    NSCachedURLResponse *modifiedCachedResponse = [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response data:cachedResponse.data userInfo:userInfo storagePolicy:cachedResponse.storagePolicy];
    
    [super storeCachedResponse:modifiedCachedResponse forRequest:request];
}

@end
