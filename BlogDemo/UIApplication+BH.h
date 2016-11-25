//
//  UIApplication+BHApplication.h
//  BlogDemo
//
//  Created by HanBin on 15/3/19.
//  Copyright © 2015年 BinHan. All rights reserved.
//

#define BHCurrentVC [UIApplication sharedApplication].currentController

#define BHPushVC(ViewController) [[UIApplication sharedApplication].currentController.navigationController pushViewController:ViewController animated:YES]

#define BHPresentVC(ViewController)\
BHNavigationController *nv=[[BHNavigationController alloc]initWithRootViewController:ViewController];\
[[UIApplication sharedApplication].currentController presentViewController:nv animated:YES completion:nil]

@interface UIApplication (BH)

/**
 *  利用runtime中的associative机制给类扩展添加属性
 */
@property(nonatomic, strong) UIViewController *currentController;


/**
 *  获取跟控制器
 *
 *  @return UIViewController
 */
+(UIViewController*)rootViewController;

@end
