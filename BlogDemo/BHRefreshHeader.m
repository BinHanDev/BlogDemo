//
//  BHHeaderView.m
//  BlogDemo
//
//  Created by HanBin on 16/5/30.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHRefreshHeader.h"

const CGFloat herderHeight = 100.f;

@interface BHRefreshHeader()
{
    /** 记录scrollView刚开始的inset */
    UIEdgeInsets _scrollViewOriginalInset;
    /** 父控件 */
    __weak UIScrollView *_scrollView;
    UIImageView *_imageView;
    /**
     *  刷新时候的图片集合
     */
    NSMutableArray *_magesArray;
}

/** 回调对象 */
@property (weak, nonatomic) id refreshingTarget;
/** 回调方法 */
@property (assign, nonatomic) SEL refreshingAction;

@property (strong, nonatomic) UIPanGestureRecognizer *pan;

@property (assign, nonatomic) BHRefreshState state;

@end



@implementation BHRefreshHeader

-(instancetype)init
{
    return [self initWithFrame:CGRectMake(0, -herderHeight, SCREEN_WIDTH, herderHeight)];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.state = BHRefreshStateIdle;
        _magesArray = [NSMutableArray array];
        for(NSInteger i = 1; i < 8; i++)
        {
            NSString *imageName = [NSString stringWithFormat:@"icon_shake_animation_%ld", i];
            [_magesArray addObject:BHIMG(imageName)];
        }
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:BHIMG(@"icon_pull_animation_1")];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_imageView = imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(2.f);
            make.height.equalTo(@(0));
        }];
    }
    return _imageView;
}

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    BHRefreshHeader *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    self.refreshingTarget = target;
    self.refreshingAction = action;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    // 旧的父控件移除监听
    [self removeObservers];
    if (newSuperview)
    {   // 新的父控件
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.contentInset;
        // 添加监听
        [self addObservers];
    }
}

#pragma mark - KVO监听
- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [_scrollView addObserver:self forKeyPath:MJRefreshKeyPathContentOffset options:options context:nil];
    [_scrollView addObserver:self forKeyPath:MJRefreshKeyPathContentSize options:options context:nil];
    self.pan = _scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:MJRefreshKeyPathPanState options:options context:nil];
}

- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:MJRefreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:MJRefreshKeyPathContentSize];
    [self.pan removeObserver:self forKeyPath:MJRefreshKeyPathPanState];
    self.pan = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled) return;
    // 这个就算看不见也需要处理
    if ([keyPath isEqualToString:MJRefreshKeyPathContentSize])
    {
        [self scrollViewContentSizeDidChange:change];
    }
    // 看不见
    if (self.hidden) return;
    if ([keyPath isEqualToString:MJRefreshKeyPathContentOffset])
    {
        [self scrollViewContentOffsetDidChange:change];
    }
    else if ([keyPath isEqualToString:MJRefreshKeyPathPanState])
    {
        [self scrollViewPanStateDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    _scrollViewOriginalInset = _scrollView.contentInset;
    CGFloat offsetY = abs((int)_scrollView.mj_offsetY);
    if ( kNavBarHeight<offsetY && offsetY< 150 && self.state == BHRefreshStateIdle)
    {
        [self.imageView stopAnimating];
        NSInteger imgIndex = (offsetY - kNavBarHeight) / 16;
        if (1<imgIndex && imgIndex< 5)
        {
            NSString *imageName = [NSString stringWithFormat:@"icon_pull_animation_%ld", imgIndex];
            self.imageView.image = BHIMG(imageName);
        }
        self.imageView.mj_h = offsetY - kNavBarHeight;
    }
    else if (offsetY >= 150)
    {
        self.imageView.mj_h = 100.f;
        [self.imageView stopAnimating];
        self.imageView.animationImages = _magesArray;
        self.imageView.animationRepeatCount = MAXFLOAT;
        [self.imageView startAnimating];
        self.state = BHRefreshStatePulling;
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    if (_scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        self.state = BHRefreshStateRefreshing;
        _scrollView.contentInset = UIEdgeInsetsMake(herderHeight + kNavBarHeight, 0, 0, 0);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             self.state = MJRefreshStateIdle;
            _scrollView.contentInset = UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0);
            [self.imageView stopAnimating];
            self.imageView.image = BHIMG(@"icon_pull_animation_1");
            [self endRefreshing];
        });
    }
}

- (void)endRefreshing
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
            MJRefreshMsgSend(MJRefreshMsgTarget(self.refreshingTarget), self.refreshingAction, self);
        }
    });
    
}



@end
