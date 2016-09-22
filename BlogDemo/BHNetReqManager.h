//
//  BHNetReqManager.h
//  BlogDemo
//
//  Created by HanBin on 16/1/26.
//  Copyright © 2016年 BinHan. All rights reserved.
//
//  http://binhan1029.github.io/2015/07/11/%E5%AF%B9AFNetworking%E7%9A%84%E9%93%BE%E5%BC%8F%E4%BA%8C%E6%AC%A1%E5%B0%81%E8%A3%85/
//

typedef NS_OPTIONS(NSUInteger, RequestType) {
    GET,
    POST,
    PUT,
    DELETE,
    PATCH,
};

typedef NS_OPTIONS(NSUInteger, RequestSerializer) {
    JSONRequestSerializer,
    HTTPRequestSerializer,
    PropertyListRequestSerializer,
};

typedef NS_OPTIONS(NSUInteger, ResponseSerializer) {
    HTTPResponseSerializer,
    JSONResponseSerializer,
    XMLParserResponseSerializer,
};

typedef NS_ENUM(NSUInteger, NetworkStates) {
    NetworkStatesNone, // 没有网络
    NetworkStates2G, // 2G
    NetworkStates3G, // 3G
    NetworkStates4G, // 4G
    NetworkStatesWIFI // WIFI
};

@interface BHNetReqManager : NSObject

/**
 *  请求url
 */
- (BHNetReqManager* (^)(NSString * url))bh_requestUrl;

/**
 *  请求类型，默认GET
 */
- (BHNetReqManager* (^)(RequestType requestType))bh_requestType;

/**
 *  请求数据类型，默认AFHTTPRequestSerializer
 */
- (BHNetReqManager* (^)(RequestSerializer serializer))bh_requestSerializer;

/**
 *  数据接收类型，默认AFJSONResponseSerializer
 */
- (BHNetReqManager* (^)(ResponseSerializer serializer))bh_responseSerializer;

/**
 *  请求参数，使用字典NSDictionary *parameters = @{@"foo": @"bar", @"baz": @[@1, @2, @3]};
 */
- (BHNetReqManager* (^)(id parameters))bh_parameters;

/** 单例对象
 @return 返回单例对象
 */
+(instancetype)sharedManager;


/** 获取网络状态
 @return 返回网络状态
 */

+ (NetworkStates)getNetworkStates;

/**
 *  开始请求
 *
 *  @param handler 请求完成后的句柄
 */
-(void)startRequestWithCompleteHandler:(void (^)(id response, NSError *error))handler;

@end
