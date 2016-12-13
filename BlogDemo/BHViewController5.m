//
//  BHViewController5.m
//  BlogDemo
//
//  Created by BinHan on 2016/2/12.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController5.h"
#import "BHPhotosCell.h"
#import <Photos/Photos.h>

@interface BHViewController5 ()<UITableViewDataSource, UITableViewDelegate>

/**
 *  数据源
 **/
@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 tableView
 */
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation BHViewController5

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // 获取所有资源的集合，并按资源的创建时间排序
//    PHFetchOptions *options = [[PHFetchOptions alloc] init];
//    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
//    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
//    [self.dataArray addObject:assetsFetchResults];
    
    // 列出所有相册智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
        if (!collection.startDate && ![self filterWithSubtype:collection])
        {
            [self.dataArray addObject:collection];
        }
    }];
    // 列出所有用户创建的相册
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    [topLevelUserCollections enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
        if (collection.estimatedAssetCount > 0)
        {
            [self.dataArray addObject:collection];
        }
    }];
    [self.tableView reloadData];
}

-(PHFetchResult *)sortWithDate:(PHAssetCollection *)collection
{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    BHLog(@"fetchResult count = %ld", fetchResult.count);
    return fetchResult;
}

-(BOOL)filterWithSubtype:(PHAssetCollection *)collection
{
    PHAssetCollectionSubtype assetCollectionSubtype = collection.assetCollectionSubtype;
    if (assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary ||  //用户相册
        assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumVideos ||       //视频
        assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumFavorites ||    //收藏
        assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumScreenshots ||  //截屏
        assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumBursts ||       //连拍
        assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumTimelapses ||   //延时摄影
        assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumSlomoVideos) //慢动作
    {
        return NO;
    }
    return YES;
}


-(void)updateViewConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark -UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHPhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:[BHPhotosCell identifier]];
    PHAssetCollection *assetCollection = self.dataArray[indexPath.row];
    cell.assetCollection = assetCollection;
    NSLog(@"assetCollection = %ld", assetCollection.estimatedAssetCount);
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

#pragma mark 分割线顶头显示

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return  _dataArray;
}


#pragma mark initSubView

-(UITableView *)tableView
{
    if (!_tableView)
    {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = rowHeight;
        tableView.tableFooterView = [UIView new];
        [tableView registerClass:[BHPhotosCell class] forCellReuseIdentifier:[BHPhotosCell identifier]];
        [self.view addSubview:(_tableView = tableView)];
        [self.view setNeedsUpdateConstraints];
    }
    return _tableView;
}


@end
