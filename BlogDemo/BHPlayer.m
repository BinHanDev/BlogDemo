//
//  BHPlayer.m
//  BlogDemo
//
//  Created by HanBin on 15/5/9.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHPlayer.h"
#import "BHPlayerControlView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

static const CGFloat BHPlayerAnimationTimeInterval = 5.0f;
static const CGFloat BHPlayerControlBarAutoFadeOutTimeInterval = 0.5f;

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, BHPanDirection) {
    BHPanDirectionHorizontalMoved, //横向移动
    BHPanDirectionVerticalMoved    //纵向移动
};

//播放器的几种状态
typedef NS_ENUM(NSInteger, BHPlayerState) {
    BHPlayerStateFailed,     // 播放失败
    BHPlayerStateBuffering,  //缓冲中
    BHPlayerStatePlaying,    //播放中
    BHPlayerStateStopped,    //停止播放
    BHPlayerStatePause       //暂停播放
};


@interface BHPlayer() <UIGestureRecognizerDelegate>

/** 
 * 播放属性 
 */
@property (nonatomic, strong) AVPlayer *player;
/**
 * 播放属性 
 */
@property (nonatomic, strong) AVPlayerItem *playerItem;
/**
 * playerLayer 
 */
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
/**
 * 控制层View 
 */
@property (nonatomic, weak) BHPlayerControlView *controlView;
/**
 * 播放完了
 */
@property (nonatomic, assign) BOOL playDidEnd;
/**
 * 进入后台
 */
@property (nonatomic, assign) BOOL didEnterBackground;
/**
 * 用来保存快进的总时长 
 */
@property (nonatomic, assign) CGFloat sumTime;
/**
 * 播发器的几种状态 
 */
@property (nonatomic, assign) BHPlayerState state;
/**
 * 是否为全屏 
 */
@property (nonatomic, assign) BOOL isFullScreen;
/**
 * 是否显示controlView
 */
@property (nonatomic, assign) BOOL isMaskShowing;
/**
 * 是否被用户暂停 
 */
@property (nonatomic, assign) BOOL isPauseByUser;
/**
 * 计时器 */
@property (nonatomic, strong) NSTimer *timer;
/**
 * slider上次的值 
 */
@property (nonatomic, assign) CGFloat sliderLastValue;
/**
 * 定义一个实例变量，保存枚举值 
 */
@property (nonatomic, assign) BHPanDirection panDirection;
/**
 * 是否在调节音量
 */
@property (nonatomic, assign) BOOL isVolume;
/**
 * 滑杆 
 */
@property (nonatomic, strong) UISlider *volumeViewSlider;

@end

@implementation BHPlayer

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self controlView];
    }
    return self;
}

-(BHPlayerControlView *)controlView
{
    if (!_controlView)
    {
        BHPlayerControlView *controlView = [[BHPlayerControlView alloc] init];
        [self addSubview:(_controlView=controlView)];
        [_controlView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
    }
    return _controlView;
}

-(void)setPlayerLayerGravity:(NSString *)playerLayerGravity
{
    _playerLayerGravity = playerLayerGravity;
}

-(void)setSourceUrl:(NSString *)sourceUrl
{
    NSAssert(sourceUrl != nil, @"必须先传入视频sourceUrl！！！");
    _sourceUrl = sourceUrl;
    [self addNotifications];
    [self configBHPlayer];
}

/**
 *  设置Player相关参数
 */
- (void)configBHPlayer
{
    // 初始化playerItem
    if([self.sourceUrl rangeOfString:@"http"].location != NSNotFound)
    {
        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[self.sourceUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    else
    {
        AVAsset *movieAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:self.sourceUrl] options:nil];
        self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    }
    //视频添加kvo监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    // 缓冲区空了，需要等待数据
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    // 缓冲区有足够数据可以播放了
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    // 每次都重新创建Player，替换replaceCurrentItemWithPlayerItem:，该方法阻塞线程
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    // 初始化playerLayer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    // 此处为默认视频填充模式
    self.playerLayer.videoGravity = self.playerLayerGravity;
    // 添加playerLayer到self.layer
    [self.layer insertSublayer:self.playerLayer atIndex:0];
    // 创建bhplayer的时候已经初始化了controlview, 初始化显示controlView为YES
    self.isMaskShowing = YES;
    // 延迟隐藏controlView，
    [self autoFadeOutControlBar];
    // 计时器
    [self createTimer];
    // 添加手势
    [self createGesture];
    // 获取系统音量
    [self configureVolume];
    self.state = BHPlayerStateBuffering;
    // 开始播放
    [self play];
    self.controlView.startBtn.selected = YES;
    self.isPauseByUser = NO;
    // 强制让系统调用layoutSubviews 两个方法必须同时写
    [self setNeedsLayout]; //是标记 异步刷新 会调但是慢
    [self layoutIfNeeded]; //加上此代码立刻刷新
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
    [UIApplication sharedApplication].statusBarHidden = NO;
    // 只要屏幕旋转就显示控制层
    self.isMaskShowing = NO;
    [self animateShow];
    // fix iOS7 crash bug
//    [self layoutIfNeeded];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.player.currentItem)
    {
        if ([keyPath isEqualToString:@"status"])
        {
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay)
            {
                self.state = BHPlayerStatePlaying;
                // 加载完成后，再添加平移手势
                // 添加平移手势，用来控制音量、亮度、快进快退
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
                pan.delegate = self;
                [self addGestureRecognizer:pan];
                // 跳到xx秒播放视频
                if (self.seekTime)
                {
                    [self seekToTime:self.seekTime completionHandler:nil];
                }
            }
            else if (self.player.currentItem.status == AVPlayerItemStatusFailed)
            {
                self.state = BHPlayerStateFailed;
                NSError *error = [self.player.currentItem error];
                self.controlView.progressIndicatorLabel.hidden = NO;
                self.controlView.progressIndicatorLabel.text = [NSString stringWithFormat:@"视频加载失败！%@",error.description];
            }
        }
        else if ([keyPath isEqualToString:@"loadedTimeRanges"])
        {
            // 计算缓冲进度
            NSTimeInterval timeInterval = [self availableDuration];
            CMTime duration = self.playerItem.duration;
            CGFloat totalDuration = CMTimeGetSeconds(duration);
            [self.controlView.progressView setProgress:timeInterval / totalDuration animated:NO];
            // 如果缓冲和当前slider的差值超过0.1,自动播放，解决弱网情况下不会自动播放问题
            if (!self.isPauseByUser && !self.didEnterBackground && (self.controlView.progressView.progress-self.controlView.videoSlider.value > 0.05))
            {
                [self play];
            }
        }
        else if ([keyPath isEqualToString:@"playbackBufferEmpty"])
        {
            // 当缓冲是空的时候
            if (self.playerItem.playbackBufferEmpty)
            {
                self.state = BHPlayerStateBuffering;
                [self bufferingSomeSecond];
            }
        }
        else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"])
        {
            // 当缓冲好的时候
            if (self.playerItem.playbackLikelyToKeepUp && self.state == BHPlayerStateBuffering)
            {
                self.state = BHPlayerStatePlaying;
            }
        }
    }
}

- (void)autoFadeOutControlBar
{
    if (!self.isMaskShowing)  return;
    //先取消延迟函数再重新调用
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlView) object:nil];
    [self performSelector:@selector(hideControlView) withObject:nil afterDelay:BHPlayerAnimationTimeInterval];
}

/**
 *  隐藏控制层
 */
- (void)hideControlView
{
    if (!self.isMaskShowing) return;
    [UIView animateWithDuration:BHPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self.controlView hideControlView];
        if (self.isFullScreen)
        {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        }
    }completion:^(BOOL finished) {
        self.isMaskShowing = NO;
    }];
}

/**
 *  显示控制层
 */
- (void)animateShow
{
    if (self.isMaskShowing) return;
    [UIView animateWithDuration:BHPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self.controlView showControlView];
        if (self.isFullScreen)
        {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        }
    } completion:^(BOOL finished) {
        self.isMaskShowing = YES;
        [self autoFadeOutControlBar];
    }];
}

/**
 *  创建timer
 */
- (void)createTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(playerTimerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *  计时器事件
 */
- (void)playerTimerAction
{
    if (_playerItem.duration.timescale != 0)
    {
        //当前进度
        self.controlView.videoSlider.value = CMTimeGetSeconds([_playerItem currentTime]) / (_playerItem.duration.value / _playerItem.duration.timescale);
        //当前时长进度progress
        NSInteger proMin = (NSInteger)CMTimeGetSeconds([_player currentTime]) / 60;//当前秒
        NSInteger proSec = (NSInteger)CMTimeGetSeconds([_player currentTime]) % 60;//当前分钟
        //duration总时长
        NSInteger durMin = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale / 60;//总秒
        NSInteger durSec = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale % 60;//总分钟
        self.controlView.currentTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
        self.controlView.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    }
}

/**
 *  创建手势
 */
- (void)createGesture
{
    // 单击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    // 双击(播放/暂停)
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTap];
    [tap requireGestureRecognizerToFail:doubleTap];
}

/**
 *   轻拍方法
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)tapAction:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        self.isMaskShowing ? ([self hideControlView]) : ([self animateShow]);
    }
}


/**
 *  双击显示控制层 播放/暂停
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)doubleTapAction:(UITapGestureRecognizer *)gesture
{
    [self animateShow];
    [self startAction:self.controlView.startBtn];
}

/**
 *  全屏按钮事件
 *
 *  @param sender 全屏Button
 */
- (void)fullScreenAction:(UIButton *)sender
{
    UIDeviceOrientation orientation  = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
            break;
        }
        case UIInterfaceOrientationPortrait:
        {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
        {
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
            break;
        }
        case UIInterfaceOrientationLandscapeRight:
        {
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
             break;
        }
        default:
        {
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
            break;
        }
    }
}


/**
 *  获取系统音量
 */
- (void)configureVolume
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    self.volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews])
    {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"])
        {
            self.volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];
    if (!success) { /* handle the error in setCategoryError */ }
}

/**
 *  播放完了
 *
 *  @param notification 通知
 */
- (void)moviePlayDidEnd:(NSNotification *)notification
{
    self.state = BHPlayerStateStopped;
//        self.controlView.backgroundColor  = RGBA(0, 0, 0, .6);
    self.playDidEnd = YES;
    // 初始化显示controlView为YES
    self.isMaskShowing = NO;
    // 延迟隐藏controlView
    [self animateShow];
}

/**
 *  添加观察者、通知
 */
- (void)addNotifications
{
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
    // slider开始滑动事件
    [self.controlView.videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    // slider滑动中事件
    [self.controlView.videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    // slider结束滑动事件
    [self.controlView.videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    // 播放按钮点击事件
    [self.controlView.startBtn addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    // 返回按钮点击事件
    [self.controlView.backBtn addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    // 全屏按钮点击事件
    [self.controlView.fullScreenBtn addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    // 监测设备方向
    [self listeningRotating];
}

/**
 *  监听设备旋转通知
 */
- (void)listeningRotating
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            self.controlView.fullScreenBtn.selected = YES;
            self.isFullScreen = YES;
            break;
        }
        case UIInterfaceOrientationPortrait:
        {
            self.isFullScreen = !self.isFullScreen;
            self.controlView.fullScreenBtn.selected = NO;
            self.isFullScreen = NO;
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
        {
            self.controlView.fullScreenBtn.selected = YES;
            self.isFullScreen = YES;
            break;
        }
        case UIInterfaceOrientationLandscapeRight:
        {
            self.controlView.fullScreenBtn.selected = YES;
            self.isFullScreen = YES;
            break;
        }
        default:
            break;
    }
}


/**
 *  应用退到后台
 */
- (void)appDidEnterBackground
{
    self.didEnterBackground = YES;
    [self pause];
    self.state = BHPlayerStatePause;
//    [self cancelAutoFadeOutControlBar];
}

/**
 *  应用进入前台
 */
- (void)appDidEnterPlayGround
{
    self.didEnterBackground = NO;
    self.isMaskShowing = NO;
    // 延迟隐藏controlView
    [self animateShow];
    [self createTimer];
    if (!self.isPauseByUser)
    {
        self.state = BHPlayerStatePlaying;
        self.controlView.startBtn.selected = YES;
        self.isPauseByUser  = NO;
        [self play];
    }
}

#pragma mark - slider事件

/**
 *  slider开始滑动事件
 *
 *  @param slider UISlider
 */
- (void)progressSliderTouchBegan:(UISlider *)slider
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        // 暂停timer
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

/**
 *  slider滑动中事件
 *
 *  @param slider UISlider
 */
- (void)progressSliderValueChanged:(UISlider *)slider
{
    //拖动改变视频播放进度
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay)
    {
        //获取slider的最新值
        self.sliderLastValue = slider.value;
        // 由于快进后退会重新缓冲视频， 所以先暂停
        [self pause];
        CGFloat total = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        //计算出拖动的当前秒数
        NSInteger dragedSeconds = floorf(total * slider.value);
        //转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        // 拖拽的时长
        NSInteger proMin = (NSInteger)CMTimeGetSeconds(dragedCMTime) / 60;//当前秒
        NSInteger proSec = (NSInteger)CMTimeGetSeconds(dragedCMTime) % 60;//当前分钟
        //duration 总时长
        NSInteger durMin = (NSInteger)total / 60;//总秒
        NSInteger durSec = (NSInteger)total % 60;//总分钟
        NSString *currentTime = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
        NSString *totalTime = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
        if (total > 0)
        {
            // 当总时长 > 0时候才能拖动slider
            self.controlView.currentTimeLabel.text = currentTime;
            self.controlView.progressIndicatorLabel.hidden = NO;
            self.controlView.progressIndicatorLabel.text = [NSString stringWithFormat:@"%@ / %@", currentTime, totalTime];
        }
        else
        {
            // 此时设置slider值为0
            slider.value = 0;
        }
    }
    else
    {
        // player状态加载失败 此时设置slider值为0
        slider.value = 0;
    }
}

/**
 *  slider结束滑动事件
 *
 *  @param slider UISlider
 */
- (void)progressSliderTouchEnded:(UISlider *)slider
{
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay)
    {
        // 继续开启timer
        [self.timer setFireDate:[NSDate date]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.controlView.progressIndicatorLabel.hidden = YES;
        });
        // 结束滑动时候把开始播放按钮改为播放状态
        self.controlView.startBtn.selected = YES;
        self.isPauseByUser = NO;
        // 滑动结束延时隐藏controlView
        [self autoFadeOutControlBar];
        // 视频总时间长度
        CGFloat total = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        //计算出拖动的当前秒数
        NSInteger dragedSeconds = floorf(total * slider.value);
        [self seekToTime:dragedSeconds completionHandler:nil];
    }
}

/**
 *  从xx秒开始播放视频跳转
 *
 *  @param dragedSeconds 视频跳转的秒数
 */
- (void)seekToTime:(NSInteger)dragedSeconds completionHandler:(void (^)(BOOL finished))completionHandler
{
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        // seekTime:completionHandler:不能精确定位
        // 如果需要精确定位，可以使用seekToTime:toleranceBefore:toleranceAfter:completionHandler:
        // 转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        [self.player seekToTime:dragedCMTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            // 视频跳转回调
            if (completionHandler)
            {
                completionHandler(finished);
            }
            // 如果点击了暂停按钮
            if (self.isPauseByUser) return;
            [self play];
            if (!self.playerItem.isPlaybackLikelyToKeepUp)
            {
                self.state = BHPlayerStateBuffering;
            }
        }];
    }
}

/**
 *  播放、暂停按钮事件
 *
 *  @param button UIButton
 */
- (void)startAction:(UIButton *)button
{
    button.selected = !button.selected;
    self.isPauseByUser = !button.isSelected;
    if (button.selected)
    {
        [self play];
        if (self.state == BHPlayerStatePause)
        {
            self.state = BHPlayerStatePlaying;
        }
    }
    else
    {
        [self pause];
        if (self.state == BHPlayerStatePlaying)
        {
            self.state = BHPlayerStatePause;
        }
    }
}

/**
 *  播放
 */
- (void)play
{
    [_player play];
}

/**
 * 暂停
 */
- (void)pause
{
    [_player pause];
}

/**
 *  返回按钮事件
 */
- (void)backButtonAction
{
    if (!self.isFullScreen)
    {
        // player加到控制器上，只有一个player时候
        [self.timer invalidate];
        [self pause];
        if (self.goBackBlock)
        {
            self.goBackBlock();
        }
    }
    else
    {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
    }
}

/**
 *  强制屏幕转屏
 *
 *  @param orientation 屏幕方向
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

/**
 *  计算缓冲进度
 *
 *  @return 缓冲进度
 */
- (NSTimeInterval)availableDuration
{
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

/**
 *  缓冲较差时候回调这里
 */
- (void)bufferingSomeSecond
{
    self.state = BHPlayerStateBuffering;
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    __block BOOL isBuffering = NO;
    if (isBuffering) return;
    isBuffering = YES;
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (self.isPauseByUser)
        {
            isBuffering = NO;
            return;
        }
        [self play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        if (!self.playerItem.isPlaybackLikelyToKeepUp)
        {
            [self bufferingSomeSecond];
        }
    });
}

/**
 *  pan手势事件
 *
 *  @param pan UIPanGestureRecognizer
 */
- (void)panDirection:(UIPanGestureRecognizer *)pan
{
    //根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:self];
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    // 判断是垂直移动还是水平移动
    switch (pan.state)
    {
        case UIGestureRecognizerStateBegan:
        { // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y)
            { // 水平移动
                // 取消隐藏
                self.controlView.progressIndicatorLabel.hidden = NO;
                self.panDirection = BHPanDirectionHorizontalMoved;
                // 给sumTime初值
                CMTime time = self.player.currentTime;
                self.sumTime = time.value/time.timescale;
                // 暂停视频播放
                [self pause];
                // 暂停timer
                [self.timer setFireDate:[NSDate distantFuture]];
            }
            else if (x < y)
            { // 垂直移动
                self.panDirection = BHPanDirectionVerticalMoved;
                // 开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > self.bounds.size.width / 2)
                {
                    self.isVolume = YES;
                }
                else
                { // 状态改为显示亮度调节
                    self.isVolume = NO;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        { // 正在移动
            switch (self.panDirection)
            {
                case BHPanDirectionHorizontalMoved:
                {
                    [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    break;
                }
                case BHPanDirectionVerticalMoved:
                {
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        { // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection)
            {
                case BHPanDirectionHorizontalMoved:
                {
                    // 继续播放
                    [self play];
                    [self.timer setFireDate:[NSDate date]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        // 隐藏视图
                        self.controlView.progressIndicatorLabel.hidden = YES;
                    });
                    // 快进、快退时候把开始播放按钮改为播放状态
                    self.controlView.startBtn.selected = YES;
                    self.isPauseByUser = NO;
                    [self seekToTime:self.sumTime completionHandler:nil];
                    // 把sumTime滞空，不然会越加越多
                    self.sumTime = 0;
                    break;
                }
                case BHPanDirectionVerticalMoved:
                {
                    // 垂直移动结束后，把状态改为不再控制音量
                    self.isVolume = NO;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.controlView.progressIndicatorLabel.hidden = YES;
                    });
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

/**
 *  pan垂直移动的方法
 *
 *  @param value void
 */
- (void)verticalMoved:(CGFloat)value
{
    self.isVolume ? (self.volumeViewSlider.value -= value / 10000) : ([UIScreen mainScreen].brightness -= value / 10000);
}

/**
 *  pan水平移动的方法
 *
 *  @param value void
 */
- (void)horizontalMoved:(CGFloat)value
{
    // 每次滑动需要叠加时间
    self.sumTime += value / 200;
    // 需要限定sumTime的范围
    CMTime totalTime = self.playerItem.duration;
    CGFloat totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
    if (self.sumTime > totalMovieDuration) { self.sumTime = totalMovieDuration;}
    if (self.sumTime < 0)
    {
        self.sumTime = 0;
    }
    // 当前快进的时间
    NSString *nowTime = [self durationStringWithTime:(int)self.sumTime];
    // 总时间
    NSString *durationTime = [self durationStringWithTime:(int)totalMovieDuration];
    // 给label赋值
    self.controlView.progressIndicatorLabel.text = [NSString stringWithFormat:@"%@ / %@", nowTime, durationTime];
}

/**
 *  根据时长求出字符串
 *
 *  @param time 时长
 *
 *  @return 时长字符串
 */
- (NSString *)durationStringWithTime:(int)time
{
    // 获取分钟
    NSString *min = [NSString stringWithFormat:@"%02d",time / 60];
    // 获取秒数
    NSString *sec = [NSString stringWithFormat:@"%02d",time % 60];
    return [NSString stringWithFormat:@"%@:%@", min, sec];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
