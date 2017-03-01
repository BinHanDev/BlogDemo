//
//  BHViewController5.m
//  BlogDemo
//
//  Created by BinHan on 2016/2/12.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController3.h"
#import "BHPhotosCell.h"
#import <Photos/Photos.h>
#import "BHPhotosVC.h"

@interface BHViewController3 ()<UITableViewDataSource, UITableViewDelegate>

/**
 *  数据源
 **/
@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 tableView
 */
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation BHViewController3

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 列出所有相册智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
        NSLog(@"collection = %ld", collection.assetCollectionSubtype);
        NSLog(@"collection localizedTitle = %@", collection.localizedTitle);
        [self.dataArray addObject:collection];
    }];
    // 列出所有用户创建的相册
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    [topLevelUserCollections enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
        [self.dataArray addObject:collection];
    }];
    [self.tableView reloadData];
}


/**
 对相册资源继续排序

 @param collection collection
 @return 返回按时间倒序后的集合
 */
-(PHFetchOptions *)fetchOptions
{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    return options;
}

/**
 过滤指定相册
 
 @param collection 相册  这里过滤全景图片/隐藏/最近删除（1000000201）
 @return 返回是否过滤
 */
-(BOOL)filterWithSubtype:(PHAssetCollection *)collection
{
    PHAssetCollectionSubtype assetCollectionSubtype = collection.assetCollectionSubtype;
    if (assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumPanoramas ||
        assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumAllHidden ||
        assetCollectionSubtype == 1000000201)
    {
        return YES;
    }
    return NO;
}

-(void)updateViewConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
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
    PHAssetCollection *assetCollection = self.dataArray[indexPath.row];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    BHPhotosVC *vc = [[BHPhotosVC alloc] init];
    vc.fetchResult = fetchResult;
    BHPushVC(vc);
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
