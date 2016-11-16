//
//  UIViewController+BHUIViewController.m
//  BlogDemo
//
//  Created by BinHan on 2016/11/16.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "UIViewController+BHUIViewController.h"
#import "BHHookUtility.h"


@implementation UIViewController (BHUIViewController)

+(void)load
{
    [BHHookUtility swizzlingInClass:[self class] originalSelector:@selector(viewWillAppear:) swizzledSelector:@selector(bh_viewWillAppear:)];
}

-(void)bh_viewWillAppear:(BOOL)animated
{
    BHCurrentVC = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self bh_viewWillAppear:animated];
}

@end
