//
//  BHViewController11.m
//  BlogDemo
//
//  Created by HanBin on 16/8/14.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController11.h"
#import "BHInputTextDelegate.h"

#define kOffset 80.f

@interface BHViewController11 ()

@property (nonatomic, strong) BHInputTextDelegate *inputTextDelegate;

@end

@implementation BHViewController11

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UITextField
    UITextField *textField = [UITextField new];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    self.inputTextDelegate = [BHInputTextDelegate creatDelegateWithLimitLength:20 textField:textField limitBlock:^{
        BHLog(@"超过长度限制了");
    }];
    textField.delegate = self.inputTextDelegate;
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(kOffset);
        make.right.equalTo(self.view).offset(-kOffset);
        make.height.equalTo(@(40.f));
    }];
    
    //UITextView
    UITextView *textView = [UITextView new];
    textView.backgroundColor = [UIColor grayColor];
    textView.delegate = self.inputTextDelegate;
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kOffset);
        make.right.equalTo(self.view).offset(-kOffset);
        make.top.equalTo(textField.mas_bottom).offset(kOffset);
        make.height.equalTo(@(kOffset));
    }];

    
    
    
}


@end
