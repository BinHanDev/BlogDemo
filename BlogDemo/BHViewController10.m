//
//  BHViewController10.m
//  BlogDemo
//
//  Created by HanBin on 16/8/8.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController10.h"
#import "UILabel+BH.h"
#import "UIButton+BH.h"

@implementation BHViewController10

#pragma mark -cricle

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self addLabel];
    [self addButton];
}

#pragma mark -private

/**
 *  创建Label
 */
-(void)addLabel
{
    UILabel *label = [[UILabel alloc] init].bh_text(@"测试文本").bh_textColor([UIColor redColor]).bh_textFont(18.f).bh_textAlignment(NSTextAlignmentCenter);
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(150.f);
        make.height.equalTo(@(45.f));
    }];
}

-(void)addButton
{
    UIButton *button = [[UIButton alloc] init].bh_title(@"测试标题").bh_titleColor([UIColor orangeColor]).bh_titleAlignment(NSTextAlignmentLeft).bh_backgroundColor([UIColor blueColor]);
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@(200.f));
    }];
}

@end
