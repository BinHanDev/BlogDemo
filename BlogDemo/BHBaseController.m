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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].currentController = self;
     NSLog(@"进入控制器：%@", [[self class] description]);
}

- (void)dealloc
{
    NSLog(@"控制器被dealloc: %@", [[self class] description]);
}

@end
