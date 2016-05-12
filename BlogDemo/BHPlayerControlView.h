//
//  BHPlayerControlView.h
//  BlogDemo
//
//  Created by HanBin on 15/5/9.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#define BHPlayerSrcName(file) [@"BHPlayer.bundle" stringByAppendingPathComponent:file]

typedef void(^BHSliderTapBlock)(CGFloat value);

@interface BHPlayerControlView : UIView

/** 
 * 开始播放按钮 
 */
@property (nonatomic, weak) UIButton *startBtn;
/**
 * 当前播放时长label 
 */
@property (nonatomic, weak) UILabel *currentTimeLabel;
/**
 * 视频总时长label 
 */
@property (nonatomic, weak) UILabel *totalTimeLabel;
/**
 * 缓冲进度条 
 */
@property (nonatomic, weak) UIProgressView *progressView;
/**
 * 滑杆 
 */
@property (nonatomic, weak) UISlider  *videoSlider;
/**
 * 全屏按钮 
 */
@property (nonatomic, weak) UIButton *fullScreenBtn;
/**
 * 快进快退指示器label 
 */
@property (nonatomic, strong) UILabel *progressIndicatorLabel;
/**
 * 返回按钮
 */
@property (nonatomic, strong) UIButton *backBtn;
/**
 * 系统菊花 
 */
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic, copy) BHSliderTapBlock sliderTapBlock;

/**
 *  显示控制器
 */
- (void)showControlView;

/**
 *  隐藏控制器
 */
- (void)hideControlView;

@end
