//
//  BHURLProtocol.h
//  BlogDemo
//
//  Created by HanBin on 2016/4/29.
//  Copyright © 2016年 BinHan. All rights reserved.
//
//  自定义URLProtocol
//  不管你是通过UIWebView, NSURLConnection 或者第三方库 (AFNetworking等)，他们都是基于NSURLConnection或者 NSURLSession实现的，
//  因此你可以通过NSURLProtocol做自定义的操作。
//  1、重定向网络请求   2、忽略网络请求，使用本地缓存     3、自定义网络请求的返回结果      4、一些全局的网络请求设置
//

@interface BHURLProtocol : NSURLProtocol

@end
