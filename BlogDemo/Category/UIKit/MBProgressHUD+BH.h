//
//  MBProgressHUD+BH.h
//  BlogDemo
//
//  Created by BinHan on 2015/11/26.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (BH)


/**
 加载中 用于一些网络加载过程中不可点击返回操作

 @param userInteractionEnabled 用户是否可以点击其他视图
 */
+(void)showIndicator:(BOOL)userInteractionEnabled;


/**
 弹出提示信息

 @param message 提示信息
 */
+(void)showHintMessage:(NSString *)message;

/**
 关闭当前的MBProgressHUD
 */
+ (void)hideHUD;

@end
