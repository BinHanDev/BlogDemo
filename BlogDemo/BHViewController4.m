//
//  BHViewController10.m
//  BlogDemo
//
//  Created by HanBin on 16/8/16.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController4.h"
#import "RACReturnSignal.h"

@interface BHViewController4()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, copy) NSString *userName;

@end

@implementation BHViewController4

#pragma mark - LifeCyle

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
    
    [[self.userNameTF.rac_textSignal flattenMap:^RACStream *(id value) {
        return [RACReturnSignal return:[NSString stringWithFormat:@"输出:%@",value]];
    }] subscribeNext:^(id x) {
        BHLog(@"x = %@", x);
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
    
    
    RACSignal *signal1 = [RACSignal createSignal: ^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendNext:@3];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"signal dispose");
        }];
    }];
    RACDisposable *disposable = [signal1 subscribeNext:^(id x) {
        NSLog(@"subscribe value = %@", x);
    } error:^(NSError *error) {
        NSLog(@"error: %@", error);
    } completed:^{
        NSLog(@"completed");
    }];
    
    [disposable dispose];
    
    return;
    /**
     *  信号内部包裹信号 使用内部信号发送内容
     *
     */
    RACSubject *signalOfsignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    [[signalOfsignals flattenMap:^RACStream *(id value) {
        // 当signalOfsignals的signals发出信号才会调用
        return value;
    }] subscribeNext:^(id x) {
        // 只有signalOfsignals的signal发出信号才会调用，因为内部订阅了bindBlock中返回的信号，也就是flattenMap返回的信号。
        // 也就是flattenMap返回的信号发出内容，才会调用。
        NSLog(@"%@aaa",x);
    }];
    // 信号的信号发送信号  内部信号发送内容
    [signalOfsignals sendNext:signal];
    [signal sendNext:@1];
    
    
    /**
     *  拼接信号
     *
     */
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
//        [subscriber sendCompleted];
        [subscriber sendNext:@10];
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@2];
         [subscriber sendNext:@2];
        return nil;
    }];
    
    RACSignal *signal2222 = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        return nil;
    }] replay];
    
    [signal2222 subscribeNext:^(id x) {
        NSLog(@"多次订阅第一个订阅者%@",x);
    }];
    
    [signal2222 subscribeNext:^(id x) {
        NSLog(@"多次订阅第二个订阅者%@",x);
        
    }];
    
    // 把signalA拼接到signalB后，signalA发送完成，signalB才会被激活。
    RACSignal *concatSignal = [signalA zipWith:signalB];
    // 以后只需要面对拼接信号开发。
    // 订阅拼接的信号，不需要单独订阅signalA，signalB
    // 内部会自动订阅。
    // 注意：第一个信号必须发送完成，第二个信号才会被激活
    [signalA subscribeNext:^(id x) {
        BHLog(@"第一个信号发送的内容 = %@", x);
    }];
    
    [concatSignal subscribeNext:^(id x) {
        NSLog(@"拼接信号%@",x);
    }];
    
    // 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dict = @{@"name":@"xmg",@"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        // 相当于以下写法
        //        NSString *key = x[0];
        //        NSString *value = x[1];
        NSLog(@"%@ %@", key, value);
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
    
    RAC(self.imageView, image) = [[[RACObserve(self, userName)
                                    deliverOn:[RACScheduler scheduler]]
                                   map:^(id user) {
                                       // 下载头像(这在后台执行.)
                                       return  [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: @"http://ios122.bj.bcebos.com/IMG_1785.PNG"]]];
                                   }]
                                  // 现在赋值在主线程完成.
                                  deliverOn:RACScheduler.mainThreadScheduler];
    
}

- (void)dealloc {
    NSLog(@"%@-释放了",self.class);
}

#pragma mark - Intial Methods

#pragma mark - Target Methods

#pragma mark - Private Method



- (void)test
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [subscriber sendNext:@"A"];
        });
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@"B"];
        [subscriber sendNext:@"Another B"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(doA:withB:) withSignals:signalA, signalB, nil];
}

- (void)doA:(NSString *)A withB:(NSString *)B
{
    NSLog(@"A:%@ and B:%@", A, B);
}

#pragma mark - Setter Getter Methods

-(UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

#pragma mark - External Delegate

@end
