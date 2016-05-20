//
//  BHBaseController.m
//  BlogDemo
//
//  Created by HanBin on 15/11/25.
//  Copyright © 2015年 BinHan. All rights reserved.
//

@implementation BHBaseController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark 

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].currentController = self;
     NSLog(@"%s ：%@",  __PRETTY_FUNCTION__, [[self class] description]);
}

- (void)dealloc
{
    NSLog(@"%s : %@", __PRETTY_FUNCTION__, [[self class] description]);
}

@end
