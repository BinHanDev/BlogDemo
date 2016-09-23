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


/**
 *  生成一张高斯模糊的图片
 *
 *  @param image 原图
 *  @param blur  模糊程度 (0~1)
 *
 *  @return 高斯模糊图片
 */
+ (UIImage *)blurImage:(UIImage *)image blur:(CGFloat)blur;

/**
 *  根据颜色生成一张图片
 *
 *  @param color 颜色
 *  @param size  图片大小
 *
 *  @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  生成圆角的图片
 *
 *  @param originImage 原始图片
 *  @param borderColor 边框原色
 *  @param borderWidth 边框宽度
 *
 *  @return 圆形图片
 */
+ (UIImage *)circleImage:(UIImage *)originImage borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

@end
