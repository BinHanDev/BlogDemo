//
//  UIImage+BHImage.h
//  BlogDemo
//
//  Created by HanBin on 16/8/19.
//  Copyright © 2016年 BinHan. All rights reserved.
//

@interface UIImage (BHImage)

/**
 *  高效设置图片圆角
 *
 *  @return 返回圆角图片
 */
- (UIImage *)cutCircleImage;

/**
 *  根据NSdata获取图片格式
 *
 *  @param data data
 *
 *  @return 返回图片格式
 *
 *  NSString *path = @"http://pic.rpgsky.net/images/2016/07/26/3508cde5f0d29243c7d2ecbd6b9a30f1.png";
 *  NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
 *
 */
- (NSString *)contentTypeForImageData:(NSData *)data;

@end
