//
//  BHViewController10.m
//  BlogDemo
//
//  Created by HanBin on 16/8/16.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController10.h"

@interface BHViewController10()

@property (nonatomic, copy) NSString *userName;

@end

@implementation BHViewController10


-(void)viewDidLoad
{
    
    [self.userNameTF.rac_textSignal subscribeNext:^(NSString *text) {
        self.userName = text;
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
    
    RAC(self.loginBT, backgroundColor) = [self.userNameTF.rac_textSignal map:^id(NSString *text) {
        return text.length > 3 ? [UIColor redColor] : [UIColor blueColor];
    }];
    
    //KVO
    [RACObserve(self, userName) subscribeNext:^(id x) {
        BHLog(@"userName = %@", x);
    }];
    
    //同时满足长度大于5按钮才可以点击
    RAC(self.loginBT, enabled) = [RACSignal combineLatest:@[self.userNameTF.rac_textSignal, self.passWordTF.rac_textSignal] reduce:^(NSString *usernameValid, NSString *passwordValid) {
        return @(usernameValid.length > 5 && passwordValid.length > 5);
    }];
    
    @weakify(self);
    
    
}

@end
