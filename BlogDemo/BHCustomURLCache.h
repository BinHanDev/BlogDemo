//
//  BHCustomURLCache.h
//  BlogDemo
//
//  Created by HanBin on 16/4/28.
//  Copyright © 2016年 BinHan. All rights reserved.
//

@interface BHCustomURLCache : NSURLCache

/**
 *  获取单例对象
 *
 *  @return 返回单利对象
 */
+ (instancetype)standardURLCache;

@end
