//
//  BHViewController6.m
//  BlogDemo
//
//  Created by HanBin on 16/4/27.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController6.h"

@implementation BHViewController6

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"请求事例" style:UIBarButtonItemStylePlain target:self action:@selector(request:)];
}

-(void)request:(UIBarButtonItem *)sender
{
    //IOS9下需针对HTTPS请求进行适配
    [[BHNetReqManager sharedManager].bh_requestUrl(@"http://binhan666.github.io/").bh_requestType(GET).bh_responseSerializer(HTTPResponseSerializer).bh_parameters(nil) startRequestWithCompleteHandler:^(id response, NSError *error) {
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
            [BHUtils showMessage:error.localizedDescription];
        }
    }];
    
}
@end
