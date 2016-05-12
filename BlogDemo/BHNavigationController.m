//
//  BHNavigationController.m
//  BlogDemo
//
//  Created by HanBin on 16/5/12.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController7.h"

@interface BHNavigationController ()

@end

@implementation BHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 *  当前controller是否支持自动旋转
 *
 */
- (BOOL)shouldAutorotate
{
    if ([self.topViewController isKindOfClass:[BHViewController7 class]])
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
    if ([self.topViewController isKindOfClass:[BHViewController7 class]])
    {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}

@end
