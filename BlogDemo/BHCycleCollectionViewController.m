//
//  BHCycleCollectionViewController.m
//  BlogDemo
//
//  Created by HanBin on 16/3/16.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHCycleCollectionViewController.h"

@interface BHBannerCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView *imageView;

+(NSString *)reuseIdentifier;

@end

@implementation BHBannerCell

-(void)addImageView:(NSString *)imgPath
{
    if (!_imageView)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:(self.imageView = imageView)];
    }
    self.imageView.image = BHIMG(imgPath);
}

+(NSString *)reuseIdentifier
{
    return @"BHBannerCell";
}

@end


@interface BHCycleCollectionViewController ()

/**
 *   图片名称数组
 */
@property(nonatomic, strong) NSMutableArray *imagesArr;

@end

@implementation BHCycleCollectionViewController

#pragma mark -circle

-(instancetype)init
{
    self = [super initWithCollectionViewLayout:[self flowLayout]];
    if (self)
    {
        self.imagesArr = [@[@"CycleUIScrollView_0",@"CycleUIScrollView_1",@"CycleUIScrollView_2",@"CycleUIScrollView_3",@"CycleUIScrollView_4"] mutableCopy];
        //将最后一个元素添加在数组头部
        [self.imagesArr insertObject:[self.imagesArr lastObject] atIndex:0];
        //将原数组0  也就是新数组的第一个元素到新数组里
        [self.imagesArr addObject:self.imagesArr[1]];
    }
    return self;
}

-(UICollectionViewFlowLayout *)flowLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0.f;
    layout.minimumLineSpacing = 0.f;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, BANNERIMAGE_HEIGHT);
    return layout;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.frame = CGRectMake(0, kNavBarHeight, SCREEN_WIDTH, BANNERIMAGE_HEIGHT);
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    [self.collectionView registerClass:[BHBannerCell class] forCellWithReuseIdentifier:[BHBannerCell reuseIdentifier]];
    [self collectionViewScrollToPage:0];
}

#pragma mark -UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagesArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BHBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[BHBannerCell reuseIdentifier] forIndexPath:indexPath];
    [cell addImageView:self.imagesArr[indexPath.item]];
    return cell;
}


//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(SCREEN_WIDTH, BANNERIMAGE_HEIGHT);
//}
//
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(-10, 0, 0, 0);
//}

#pragma mark -UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView)
    {
        NSInteger page = [self currentPageIndexOffset:scrollView.contentOffset];
        //滑动到第一页
        if (page == 0)
        {
            [self collectionViewScrollToPage:self.imagesArr.count - 2];
        }
        //滑动到最后一页
        if (page == self.imagesArr.count - 1)
        {
            [self collectionViewScrollToPage:1];
        }
    }
}

-(NSInteger)currentPageIndexOffset:(CGPoint)offset
{
    return offset.x / SCREEN_WIDTH;
}

-(void)collectionViewScrollToPage:(NSInteger)page
{
    CGPoint offset = CGPointMake(page * SCREEN_WIDTH, 0);
    self.collectionView.contentOffset = offset;
}

@end
