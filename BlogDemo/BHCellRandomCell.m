//
//  BHCellRandomCell.m
//  BlogDemo
//
//  Created by HanBin on 16/3/9.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHCellRandomCell.h"

static NSString *CollectionViewIdentifier = @"CollectionViewIdentifier";

@interface BHCellRandomCell()<UICollectionViewDataSource, UICollectionViewDelegate>

/**
 * 将不定数量的view在collectionView中展示
 **/
@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation BHCellRandomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0.f;
        layout.minimumLineSpacing = 0.f;
        layout.itemSize = CGSizeMake(50.f, 50.f);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewIdentifier];
        collectionView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:(self.collectionView = collectionView)];
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    [self.collectionView reloadData];
    self.collectionView.mj_h = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = [BHUtils randomColor];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate )
    {
        [self.delegate chickItem:_dataArr[indexPath.row]];
    }
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(50.f, 50.f);
//}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

+(NSString *)identifier
{
    return @"BHCellRandomCell";
}

@end
