//
//  UIViewController+BHUIViewController.m
//  BlogDemo
//
//  Created by BinHan on 2016/11/16.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "UIViewController+BH.h"
#import "BHHookUtility.h"


@implementation UIViewController (BH)

+(void)load
{
    [BHHookUtility swizzlingInClass:[self class] originalSelector:@selector(viewDidLoad) swizzledSelector:@selector(bh_viewDidLoad)];
    [BHHookUtility swizzlingInClass:[self class] originalSelector:@selector(viewWillAppear:) swizzledSelector:@selector(bh_viewWillAppear:)];
}

-(void)bh_viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self bh_viewDidLoad];
}

-(void)bh_viewWillAppear:(BOOL)animated
{
    BHCurrentVC = self;
    [self bh_viewWillAppear:animated];
}

@end
