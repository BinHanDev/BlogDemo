//
//  BHViewController6.m
//  BlogDemo
//
//  Created by HanBin on 16/4/27.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController1.h"

@implementation BHViewController1

#pragma mark -cricle

-(void)viewDidLoad
{
    [super viewDidLoad];
    //直接请求  iOS9下需针对HTTP请求进行适配
    [[BHNetReqManager sharedManager].bh_requestUrl(@"http://binhan1029.github.io/").bh_requestType(GET).bh_responseSerializer(HTTPResponseSerializer).bh_parameters(nil) startRequestWithCompleteHandler:^(id response, NSError *error) {
        if (response)
        {
            NSString *result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            UILabel *textLable = [UILabel new];
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[result dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            textLable.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20.f, 0);
            textLable.numberOfLines = 0;
            textLable.attributedText = attrStr;
            [textLable sizeToFit];
            [self.view addSubview:textLable];
        }
        else if(error)
        {
            [MBProgressHUD showHintMessage:error.localizedDescription];
        }
    }];
}

@end
