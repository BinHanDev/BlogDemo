//
//  UIViewController+BHUIViewController.m
//  BlogDemo
//
//  Created by BinHan on 2015/11/16.
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
    if ([self checkSelfClassType])
    {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    [self bh_viewDidLoad];
}

-(void)bh_viewWillAppear:(BOOL)animated
{
    if ([self checkSelfClassType])
    {
        BHCurrentVC = self;
    }
    [self bh_viewWillAppear:animated];
}


/**
 排除一些特殊的类型
 
 @return return value description
 */
-(BOOL)checkSelfClassType
{
    if ([[self.class description] hasPrefix:@"BH"])
    {
        return YES;
    }
    return NO;
}

@end
