//
//  BHCycleUIScrollViewController.m
//  BlogDemo
//
//  Created by HanBin on 16/3/16.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController3.h"
#import "BHCycleCollectionViewController.h"

@interface BHViewController3 ()<UIScrollViewDelegate>

/**
 *  图片名称数组
 */
@property (nonatomic, strong) NSArray *imagesArr;
/**
 *  当前在展示的imageview序号
 */
@property (nonatomic, assign) NSInteger middlePosition;
/**
 *  用与横向滚动的scrollView
 */
@property (nonatomic, weak) UIScrollView *scrollView;
/**
 *  将所有的imageview的数组
 */
@property (nonatomic, strong) NSMutableArray *imageViewArr;
@property (nonatomic, assign) CGFloat startOffsetX;
@property (nonatomic, assign) CGFloat endOffsetX;

@end

@implementation BHViewController3

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.imageViewArr = [NSMutableArray array];
        self.imagesArr = @[@"CycleUIScrollView_0",@"CycleUIScrollView_1",@"CycleUIScrollView_2",@"CycleUIScrollView_3",@"CycleUIScrollView_4"];
    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加BHCycleCollectionViewController试图
    BHCycleCollectionViewController *controller = [[BHCycleCollectionViewController alloc] init];
    [self addChildViewController:controller];
    [self.view addSubview:controller.collectionView];
    [controller didMoveToParentViewController:self];
    [self setupBanner];
}

/**
 *  初始化banner，包含UIScrollView及UIImageView
 *  此方法我们仅仅使用三张张UIImageView进行极端优化，并假设三张UIimageView是按顺序左右排列
 */
-(void)setupBanner
{
    if (!self.scrollView)
    {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,  250.F, SCREEN_WIDTH, BANNERIMAGE_HEIGHT)];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3.f, BANNERIMAGE_HEIGHT);
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:(self.scrollView = scrollView)];
    }
    CGRect bounds = self.scrollView.bounds;
    for (NSInteger i = 0; i < 3; i++)
    {
        UIImageView *view = [[UIImageView alloc] initWithFrame:bounds];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.clipsToBounds = YES;
        view.tag = i;
        view.mj_x = CGRectGetWidth(bounds) * i;
        view.image = BHIMG(self.imagesArr[i]);
        [self.imageViewArr addObject:view];
        [self.scrollView addSubview:view];
    }
    self.middlePosition = 1;
    [self scrollViewOffsetXWithPage:self.middlePosition];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    self.endOffsetX = scrollView.contentOffset.x;
}

/**
 *  如果滑到距离过小，则直接返回，否则切换图片的时候循环效果看起来不会太真实
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
 
    if (fabs(self.startOffsetX - self.endOffsetX) < SCREEN_WIDTH / 2.f)
    {
        return;
    }
    [self scrollViewOffsetXWithPage:1];
    if (self.scrollView == scrollView)
    {
        //向左滑动
        if (self.endOffsetX > self.startOffsetX)
        {
            ((UIImageView *)[self.imageViewArr firstObject]).image = BHIMG(self.imagesArr[self.middlePosition]);
            self.middlePosition++;
            if (self.middlePosition == self.imagesArr.count)
            {
                self.middlePosition = 0;
                ((UIImageView *)[self.imageViewArr lastObject]).image = BHIMG(self.imagesArr[self.middlePosition + 1]);
            }
            else if (self.middlePosition + 1== self.imagesArr.count)
            {
                ((UIImageView *)[self.imageViewArr lastObject]).image = BHIMG(self.imagesArr[0]);
            }
            else
            {
                ((UIImageView *)[self.imageViewArr lastObject]).image = BHIMG(self.imagesArr[self.middlePosition + 1]);
            }
            ((UIImageView *)self.imageViewArr[1]).image = BHIMG(self.imagesArr[self.middlePosition]);
        }
        //向右滑动
        if(self.endOffsetX < self.startOffsetX)
        {
            ((UIImageView *)[self.imageViewArr lastObject]).image = BHIMG(self.imagesArr[self.middlePosition]);
            self.middlePosition--;
            if (self.middlePosition == -1)
            {
                self.middlePosition = self.imagesArr.count - 1;
                ((UIImageView *)[self.imageViewArr firstObject]).image = BHIMG(self.imagesArr[self.middlePosition - 1]);
            }
            else if (self.middlePosition -1 == -1)
            {
                ((UIImageView *)[self.imageViewArr firstObject]).image = BHIMG([self.imagesArr lastObject]);
            }
            else
            {
                ((UIImageView *)[self.imageViewArr firstObject]).image = BHIMG(self.imagesArr[self.middlePosition - 1]);
            }
            ((UIImageView *)self.imageViewArr[1]).image = BHIMG(self.imagesArr[self.middlePosition]);
        }
    }
}

-(void)scrollViewOffsetXWithPage:(NSInteger)page
{
    CGPoint offset = CGPointMake(page * SCREEN_WIDTH, 0);
    self.scrollView.contentOffset = offset;
}

@end
