//
//  BHCustomURLCache.h
//  BlogDemo
//
//  Created by HanBin on 16/4/28.
//  Copyright © 2016年 BinHan. All rights reserved.
//
//  http://binhan1029.github.io/2015/07/12/%E4%B8%BAAFNetWorking%E6%B7%BB%E5%8A%A0%E6%8E%A5%E5%8F%A3%E7%BC%93%E5%AD%98/
//

@interface BHCustomURLCache : NSURLCache

/**
 *  获取单例对象
 *
 *  @return 返回单利对象
 */
+ (instancetype)standardURLCache;

@end
