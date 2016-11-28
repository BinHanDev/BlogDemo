//
//  BHViewController7.m
//  BlogDemo
//
//  Created by HanBin on 15/5/9.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController2.h"
#import "BHPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface BHViewController2 ()

@property (weak, nonatomic) BHPlayer *playerView;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;

@end

#pragma mark -cricle

@implementation BHViewController2

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化添加playerView
    BHPlayer *playerView = [[BHPlayer alloc] init];
    [self.view addSubview:(self.playerView = playerView)];
    //设置视频宽高比例16:9
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20.f);
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f/16.0f);
    }];
    __weak typeof(self) weakSelf = self;
    self.playerView.goBackBlock = ^(){
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    //网络视频
//    NSString *videoUrl = [@"http://v.jxvdy.com/sendfile/w5bgP3A8JgiQQo5l0hvoNGE2H16WbN09X-ONHPq3P3C1BISgf7C-qVs6_c8oaw3zKScO78I--b0BGFBRxlpw13sf2e54QA" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //本地视频
    NSString *videoUrl = [[NSBundle mainBundle] pathForResource:@"snow" ofType:@"mp4"];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playerView.sourceUrl = videoUrl;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait)
    {
        self.view.backgroundColor = [UIColor whiteColor];
         [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self.view).offset(20);
         }];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        self.view.backgroundColor = [UIColor blackColor];
         [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self.view).offset(0);
         }];
    }
}

@end
