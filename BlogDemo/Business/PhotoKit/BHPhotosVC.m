//
//  BHPhotosVC.m
//  BlogDemo
//
//  Created by BinHan on 2017/2/28.
//  Copyright © 2017年 BinHan. All rights reserved.
//

#import "BHPhotosVC.h"
#import "BHAlbumCell.h"

@interface BHPhotosVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/**
 CollectionView
 */
@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation BHPhotosVC

#pragma mark -cricle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setNeedsUpdateConstraints];
}

- (void)dealloc
{
    NSLog(@"%@-dealloc",self.class);
}

#pragma mark - Intial Methods

-(void)updateViewConstraints
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0));
    }];
    [super updateViewConstraints];
}

#pragma mark - Target Methods

#pragma mark - Private Method

#pragma mark - Setter Getter Methods

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        flowLayOut.minimumInteritemSpacing = 0.f;
        flowLayOut.minimumLineSpacing = 0.f;
        flowLayOut.itemSize = CGSizeMake(SCREEN_WIDTH / 4.f, SCREEN_WIDTH / 4.f);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayOut];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[BHAlbumCell class] forCellWithReuseIdentifier:[BHAlbumCell identifier]];
        [self.view addSubview: (_collectionView = collectionView)];
    }
    return _collectionView;
}

#pragma mark - External Delegate

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.fetchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BHAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[BHAlbumCell identifier] forIndexPath:indexPath];
    PHAsset *asset = self.fetchResult[indexPath.item];
    cell.assetModel = asset;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}


@end
