//
//  BHNavigationController.m
//  BlogDemo
//
//  Created by HanBin on 15/5/12.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController2.h"

@interface BHNavigationController ()

@end

@implementation BHNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
}

/**
 *  当前controller是否支持自动旋转
 *
 */
- (BOOL)shouldAutorotate
{
    if ([self.topViewController isKindOfClass:[BHViewController2 class]])
    {
        return YES;
    }
    return NO;
}

/**
 *  当前controller 支持的屏幕方向
 *
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([self.topViewController isKindOfClass:[BHViewController2 class]])
    {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}

@end
