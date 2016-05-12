//
//  BHNetReqManager.h
//  BlogDemo
//
//  Created by HanBin on 16/1/26.
//  Copyright © 2016年 BinHan. All rights reserved.
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

@interface BHNetReqManager : NSObject

+(instancetype)sharedManager;

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

/**
 *  开始请求
 *
 *  @param handler 请求完成后的句柄
 */
-(void)startRequestWithCompleteHandler:(void (^)(id response, NSError *error))handler;

@end
