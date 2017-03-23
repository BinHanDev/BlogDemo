//
//  UIButton+BHButton.m
//  BlogDemo
//
//  Created by HanBin on 16/2/8.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "UIButton+BH.h"

@implementation UIButton (BH)

-(UIButton *(^)(NSString *title))bh_title
{
    return ^UIButton *(NSString *title) {
        [self setTitle:title forState:UIControlStateNormal];
        return self;
    };
}

-(UIButton *(^)(UIColor *color))bh_titleColor
{
    return ^UIButton *(UIColor *color) {
        [self setTitleColor:color forState:UIControlStateNormal];
        return self;
    };
}

-(UIButton *(^)(CGFloat fontSize))bh_titleFont
{
    return ^UIButton *(CGFloat fontSize) {
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        return self;
    };
}

-(UIButton *(^)(NSTextAlignment titleAlignment))bh_titleAlignment
{
    return ^UIButton *(NSTextAlignment titleAlignment) {
        self.titleLabel.textAlignment = titleAlignment;
        return self;
    };
}

-(UIButton *(^)(UIColor *color))bh_backgroundColor
{
    return ^UIButton *(UIColor *color) {
        self.backgroundColor = color;
        return self;
    };
}

@end
