//
//  UIApplication+BHApplication.m
//  BlogDemo
//
//  Created by HanBin on 15/3/19.
//  Copyright © 2015年 BinHan. All rights reserved.
//

@implementation UIApplication (BH)

#pragma mark -associated currentController

-(void)setCurrentController:(UIViewController *)currentController
{
     objc_setAssociatedObject(self, @selector(currentController), currentController, OBJC_ASSOCIATION_RETAIN);
}

-(UIViewController *)currentController
{
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark -rootViewController

+(UIViewController*)rootViewController
{
    return [self sharedApplication].delegate.window.rootViewController;
}

@end
