//
//  BHViewController10.m
//  BlogDemo
//
//  Created by HanBin on 16/8/16.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController10.h"

@implementation BHViewController10


-(void)viewDidLoad
{
    
    [self.userNameTF.rac_textSignal subscribeNext:^(id x) {
        BHLog(@"x = %@", x);
    }];
    
    [[self.userNameTF.rac_textSignal filter:^BOOL(id value) {
        NSString *userName = value;
        return userName.length > 3;
    }] subscribeNext:^(id x) {
        BHLog(@"用户名大于3了");
    }];
    
    [[self.loginBT rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        BHLog(@"点击了登录");
    }];
}

@end
