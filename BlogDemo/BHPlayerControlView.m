//
//  BHPlayerControlView.m
//  BlogDemo
//
//  Created by HanBin on 15/5/9.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHPlayerControlView.h"

@interface BHPlayerControlView()

/** 
 * bottomView
 */
@property (nonatomic, weak) UIImageView *bottomImageView;
/**
 * topView 
 */
@property (nonatomic, weak) UIImageView *topImageView;

@end

@implementation BHPlayerControlView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //顶部topImageView, 将返回按钮添加到topImageView
        [self topImageView];
        [self backBtn];
        //底部bottomImageView 将开始/时间/进度条/全屏添加在bottomImageView
        [self bottomImageView];
        [self startBtn];
        [self currentTimeLabel];
        [self totalTimeLabel];
        [self progressView];
        [self videoSlider];
        [self fullScreenBtn];
        [self progressIndicatorLabel];
        [self activity];
        //由于进度条及拖动slider与时间lable未知有关，所以注意先后顺序
        [self makeSubViewsConstraints];
    }
    return self;
}

/**
 *  设置子空间约束，采用Masonry设置约束，不需要重写layoutSubviews方法
 */
- (void)makeSubViewsConstraints
{
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self);
        make.height.mas_equalTo(80);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(15);
        make.top.equalTo(self.mas_top).offset(5);
        make.width.height.mas_equalTo(30);
    }];
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(5);
        make.bottom.equalTo(self.bottomImageView.mas_bottom).offset(-5);
        make.width.height.mas_equalTo(30);
    }];
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(-5);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.startBtn.mas_trailing).offset(-3);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(43);
    }];
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.fullScreenBtn.mas_leading).offset(3);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(43);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(self.currentTimeLabel.mas_centerY).offset(-1);
        make.height.mas_equalTo(30);
    }];
    [self.progressIndicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(40);
        make.center.equalTo(self);
    }];
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (UIImageView *)topImageView
{
    if (!_topImageView)
    {
        UIImageView *topImageView  = [[UIImageView alloc] init];
        //一定要设置为YES，否则内部btn不相应点击时间
        topImageView.userInteractionEnabled = YES;
        topImageView.image = BHIMG(BHPlayerSrcName(@"top_shadow"));
        [self addSubview:(_topImageView = topImageView)];
    }
    return _topImageView;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:BHIMG(BHPlayerSrcName(@"play_back_full")) forState:UIControlStateNormal];
        [self.topImageView addSubview:(_backBtn = backBtn)];
    }
    return _backBtn;
}

- (UIImageView *)bottomImageView
{
    if (!_bottomImageView)
    {
        UIImageView *bottomImageView = [[UIImageView alloc] init];
        //一定要设置为YES，否则内部btn不相应点击时间
        bottomImageView.userInteractionEnabled = YES;
        bottomImageView.image = BHIMG(BHPlayerSrcName(@"bottom_shadow"));
        [self addSubview:(_bottomImageView=bottomImageView)];
    }
    return _bottomImageView;
}

- (UIButton *)startBtn
{
    if (!_startBtn)
    {
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBtn setImage:BHIMG(BHPlayerSrcName(@"video-player-play")) forState:UIControlStateNormal];
        [startBtn setImage:BHIMG(BHPlayerSrcName(@"video-player-pause")) forState:UIControlStateSelected];
        [self.bottomImageView addSubview:(_startBtn = startBtn)];
    }
    return _startBtn;
}

- (UILabel *)currentTimeLabel
{
    if (!_currentTimeLabel)
    {
        UILabel *currentTimeLabel = [[UILabel alloc] init];
        currentTimeLabel.textColor = [UIColor whiteColor];
        currentTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self.bottomImageView addSubview:(_currentTimeLabel = currentTimeLabel)];
    }
    return _currentTimeLabel;
}

- (UILabel *)totalTimeLabel
{
    if (!_totalTimeLabel)
    {
        UILabel *totalTimeLabel = [[UILabel alloc] init];
        totalTimeLabel.textColor = [UIColor whiteColor];
        totalTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self.bottomImageView addSubview:(_totalTimeLabel = totalTimeLabel)];
    }
    return _totalTimeLabel;
}

- (UIProgressView *)progressView
{
    if (!_progressView)
    {
        UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        progressView.trackTintColor= [UIColor clearColor];
        [self.bottomImageView addSubview:(_progressView = progressView)];
    }
    return _progressView;
}

- (UISlider *)videoSlider
{
    if (!_videoSlider)
    {
        UISlider *videoSlider = [[UISlider alloc] init];
        // 设置slider
        [videoSlider setThumbImage:BHIMG(BHPlayerSrcName(@"slider")) forState:UIControlStateNormal];
        videoSlider.maximumValue = 1;
        videoSlider.minimumTrackTintColor = [UIColor whiteColor];
        videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        [self.bottomImageView addSubview:(_videoSlider = videoSlider)];
    }
    return _videoSlider;
}

- (UIButton *)fullScreenBtn
{
    if (!_fullScreenBtn)
    {
        UIButton *fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [fullScreenBtn setImage:BHIMG(BHPlayerSrcName(@"video-player-fullscreen")) forState:UIControlStateNormal];
        [fullScreenBtn setImage:BHIMG(BHPlayerSrcName(@"video-player-shrinkscreen")) forState:UIControlStateSelected];
        [self.bottomImageView addSubview:(_fullScreenBtn = fullScreenBtn)];
    }
    return _fullScreenBtn;
}

- (UILabel *)progressIndicatorLabel
{
    if (!_progressIndicatorLabel)
    {
        UILabel *horizontalLabel = [[UILabel alloc] init];
        horizontalLabel.textColor = [UIColor whiteColor];
        horizontalLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:(_progressIndicatorLabel = horizontalLabel)];
    }
    return _progressIndicatorLabel;
}

- (UIActivityIndicatorView *)activity
{
    if (!_activity)
    {
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:(_activity = activity)];
    }
    return _activity;
}

- (void)showControlView
{
    self.topImageView.alpha = 1;
    self.bottomImageView.alpha = 1;
    self.backBtn.alpha = 1;
}

- (void)hideControlView
{
    self.topImageView.alpha = 0;
    self.bottomImageView.alpha = 0;
    self.backBtn.alpha = 0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
