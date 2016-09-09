//
//  UILabel+BHLabel.h
//  BlogDemo
//
//  Created by HanBin on 16/8/8.
//  Copyright © 2016年 BinHan. All rights reserved.
//
//  使用链式方法创建UILabel  主要添加了几个常用的属性
//

@interface UILabel (BHLabel)

/**
 *  文本内容
 */
-(UILabel *(^)(NSString *text))bh_text;

/**
 *  文本颜色
 */
-(UILabel *(^)(UIColor *color))bh_textColor;

/**
 *  文本字体大小
 */
-(UILabel *(^)(CGFloat fontSize))bh_textFont;

/**
 *  文本居中方式
 */
-(UILabel *(^)(NSTextAlignment textAlignment))bh_textAlignment;

@end
