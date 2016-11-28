//
//  UIButton+BHButton.h
//  BlogDemo
//
//  Created by HanBin on 16/2/8.
//  Copyright © 2016年 BinHan. All rights reserved.
//
//  http://binhan1029.github.io/2016/08/08/%E9%93%BE%E5%BC%8F%E5%88%9B%E5%BB%BAUILabel%E5%92%8CUIButton/
//

@interface UIButton (BH)

/**
 *  title文本内容
 */
-(UIButton *(^)(NSString *title))bh_title;

/**
 *  文本颜色
 */
-(UIButton *(^)(UIColor *color))bh_titleColor;

/**
 *  文本字体大小
 */
-(UIButton *(^)(CGFloat fontSize))bh_titleFont;

/**
 *  titleColor文本居中方式
 */
-(UIButton *(^)(NSTextAlignment titleAlignment))bh_titleAlignment;

/**
 *  背景颜色
 */
-(UIButton *(^)(UIColor *color))bh_backgroundColor;

@end
