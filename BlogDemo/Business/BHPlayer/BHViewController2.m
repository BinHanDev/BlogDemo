//
//  BHViewController7.m
//  BlogDemo
//
//  Created by HanBin on 15/5/9.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController2.h"
#import "BHPlayer.h"

@interface BHViewController2 ()

/**
 播放器视图
 */
@property (weak, nonatomic) BHPlayer *player;

@end

#pragma mark -cricle

@implementation BHViewController2

- (void)viewDidLoad
{
    [super viewDidLoad];
    //网络视频
//    NSString *videoUrl = [@"http://v.jxvdy.com/sendfile/w5bgP3A8JgiQQo5l0hvoNGE2H16WbN09X-ONHPq3P3C1BISgf7C-qVs6_c8oaw3zKScO78I--b0BGFBRxlpw13sf2e54QA" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //本地视频
    NSString *videoUrl = [[NSBundle mainBundle] pathForResource:@"snow" ofType:@"mp4"];
    self.player.sourceUrl = videoUrl;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.player resetPlayer];
}

- (void)dealloc {
    NSLog(@"%@-释放了",self.class);
}

-(void)updateViewConstraints
{
    @weakify(self);
    [self.player mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view).offset(kNavBarHeight);
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.player.mas_width).multipliedBy(9.0f/16.0f);
    }];
    [super updateViewConstraints];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait)
    {
        self.view.backgroundColor = [UIColor whiteColor];
         [self.player mas_updateConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self.view).offset(20);
         }];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        self.view.backgroundColor = [UIColor blackColor];
         [self.player mas_updateConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self.view).offset(0);
         }];
    }
}


-(BHPlayer *)player
{
    if (!_player)
    {
        BHPlayer *player = [BHPlayer new];
        [self.view addSubview:(_player = player)];
        @weakify(self);
        player.goBackBlock = ^(){
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        };
    }
    return _player;
}

@end
