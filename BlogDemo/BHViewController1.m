//
//  BHViewController6.m
//  BlogDemo
//
//  Created by HanBin on 16/4/27.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController1.h"
#import "UILabel+BH.h"
#import "UIButton+BH.h"

@interface BHViewController1()

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) RACCommand *afnCommand;

@property (nonatomic, strong) NSMutableAttributedString * attrStr;

@end

@implementation BHViewController1

#pragma mark -cricle

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.label];
    [self.view addSubview:self.button];
    [self.view setNeedsUpdateConstraints];
//    RAC(self.label, text) = [RACObserve(self, attrStr) distinctUntilChanged];
    [self.afnCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"x = %@", x);
    }];
}

-(void)updateViewConstraints
{
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(100.f);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.button.mas_bottom).mas_offset(50.f);
    }];
    [super updateViewConstraints];
}

-(UIButton *)button
{
    if (!_button)
    {
        _button = [UIButton buttonWithType:UIButtonTypeSystem].bh_title(@"链式创建UlButton").bh_titleColor([UIColor blueColor]);
        [[_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            });
//            [self.afnCommand execute:nil];
        }];
    }
    return  _button;
}

-(UILabel *)label
{
    if (!_label)
    {
        _label = [[UILabel alloc] init].bh_textColor([UIColor redColor]).bh_textFont(14.f).bh_numberOfLines(0).bh_textAlignment(NSTextAlignmentCenter).bh_text(@"链式创建UlLable");
    }
    return _label;
}

-(RACCommand *)afnCommand
{
    if (!_afnCommand)
    {
        _afnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @weakify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                   //直接请求  iOS9下需针对HTTP请求进行适配
                   [[BHNetReqManager sharedManager].bh_requestUrl(@"http://binhan1029.github.io/").bh_requestType(GET).bh_responseSerializer(HTTPResponseSerializer).bh_parameters(nil) startRequestWithCompleteHandler:^(id response, NSError *error) {
                       @strongify(self);
                       if (response)
                       {
                           NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
                           NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[result dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                           self.attrStr = attrStr;
                           [subscriber sendCompleted];
                       }
                       else if(error)
                       {
                           [MBProgressHUD showHintMessage:error.localizedDescription];
                       }
                   }];
               return nil;
           }];
        }];
    }
    return _afnCommand;
}


@end
