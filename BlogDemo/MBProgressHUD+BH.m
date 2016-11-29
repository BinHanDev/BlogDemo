//
//  MBProgressHUD+BH.m
//  BlogDemo
//
//  Created by BinHan on 2015/11/26.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "MBProgressHUD+BH.h"

@implementation MBProgressHUD (BH)

+(void)showIndicator:(BOOL)userInteractionEnabled
{
    UIWindow *window  = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.userInteractionEnabled = userInteractionEnabled;
    [hud show:YES];
}

+(void)showHintMessage:(NSString *)message
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.margin = 15.f;
    hud.yOffset = 15.f;
    hud.color = [[UIColor blackColor] colorWithAlphaComponent:0.8f];//这儿表示无背景
    hud.detailsLabelText = message;
    [hud hide:YES afterDelay:1.5f];
}

+ (void)hideHUD
{
    UIWindow *window  = [UIApplication sharedApplication].keyWindow;
    for (UIView *view in window.subviews)
    {
        if ([view isKindOfClass:[self class]])
        {
            [view removeFromSuperview];
        }
    }
}

@end
