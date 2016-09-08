//
//  BHBaseController.m
//  BlogDemo
//
//  Created by HanBin on 15/11/25.
//  Copyright © 2015年 BinHan. All rights reserved.
//

@implementation BHBaseController

#pragma mark -circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].currentController = self;
     NSLog(@"%s ：%@",  __PRETTY_FUNCTION__, [[self class] description]);
}

#pragma mark -dealloc

- (void)dealloc
{
    NSLog(@"%s : %@", __PRETTY_FUNCTION__, [[self class] description]);
}

@end
