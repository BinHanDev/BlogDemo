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
    
    // 1.创建信号
    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // block调用时刻：每当有订阅者订阅信号，就会调用block。
        
        // 2.发送信号
        [subscriber sendNext:@1];
        
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            
            // 执行完Block后，当前信号就不在被订阅了。
            
            NSLog(@"信号被销毁");
            
        }];
    }];
    
    // 3.订阅信号,才会激活信号.
    [siganl subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"接收到数据:%@",x);
    }];
    
}

@end
