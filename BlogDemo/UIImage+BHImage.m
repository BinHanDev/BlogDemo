//
//  UIImage+BHImage.m
//  BlogDemo
//
//  Created by HanBin on 16/8/19.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "UIImage+BHImage.h"

@implementation UIImage (BHImage)

- (UIImage *)cutCircleImage
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    // 获取上下文
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    // 设置圆形
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctr, rect);
    // 裁剪
    CGContextClip(ctr);
    // 将图片画上去
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
