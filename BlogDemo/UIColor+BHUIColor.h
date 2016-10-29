//
//  UIColor+BHUIColor.h
//  BlogDemo
//
//  Created by HanBin on 2015/10/29.
//  Copyright © 2015年 BinHan. All rights reserved.
//


@interface UIColor (BHUIColor)

/*
 * 16进制颜色(html颜色值)字符串转为UIColor
 */
+ (UIColor *)hexStringToColor:(NSString *)stringToConvert;

/**
 *  随机出一个色值
 *
 *  @return
 */
+(UIColor *) randomColor;

@end
