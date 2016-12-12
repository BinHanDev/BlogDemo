//
//  BHViewController5.m
//  BlogDemo
//
//  Created by BinHan on 2016/12/12.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController5.h"
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
        if (collection.estimatedAssetCount > 0)
        {
            NSLog(@"相册名字:%@", collection.localizedTitle);
            [self.dataArray addObject:collection];
        }
        
    }];
    
    // 这时 smartAlbums 中保存的应该是各个智能相册对应的 PHAssetCollection
    for (NSInteger i = 0; i < smartAlbums.count; i++)
    {
        // 获取一个相册（PHAssetCollection）
        PHCollection *collection = smartAlbums[i];
        if ([collection isKindOfClass:[PHAssetCollection class]])
        {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
            BHLog(@"fetchResult count = %ld", fetchResult.count);
            [self.dataArray addObject:assetCollection];
        }
        else
        {
            NSAssert(NO, @"Fetch collection not PHCollection: %@", collection);
        }
    }
    
    // 列出所有用户创建的相册
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    for (NSInteger i = 0; i < topLevelUserCollections.count; i++)
    {
        // 获取一个相册（PHAssetCollection）
        PHCollection *collection = topLevelUserCollections[i];
        if ([collection isKindOfClass:[PHAssetCollection class]])
        {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
            BHLog(@"fetchResult count = %ld", fetchResult.count);
            [self.dataArray addObject:assetCollection];
        }
        else
        {
            NSAssert(NO, @"Fetch collection not PHCollection: %@", collection);
        }
    }
    [self.tableView reloadData];
    
//    // 获取所有资源的集合，并按资源的创建时间排序
//    PHFetchOptions *options = [[PHFetchOptions alloc] init];
//    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
//    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
//    
//    // 在资源的集合中获取第一个集合，并获取其中的图片
//    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
//    PHAsset *asset = assetsFetchResults[0];
//    [imageManager requestImageForAsset:asset
//                            targetSize:SomeSize
//                           contentMode:PHImageContentModeAspectFill
//                               options:nil
//                         resultHandler:^(UIImage *result, NSDictionary *info) {
//                             
//                             // 得到一张 UIImage，展示到界面上
//                             
//                         }];
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
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    PHAssetCollection *assetCollection = self.dataArray[indexPath.row];
    cell.textLabel.text = assetCollection.localizedTitle;
    NSLog(@"assetCollection = %ld", assetCollection.estimatedAssetCount);
    return cell;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return  _dataArray;
//    [self.dataArray removeAllObjects];
//    for (NSInteger i = 0; i < 20; i++)
//    {
//        [self.dataArray addObject:[NSString stringWithFormat:@"test随机数据 %d", (int)arc4random() % 100]];
//    }
//    [self.tableView reloadData];
}


#pragma mark initSubView

-(UITableView *)tableView
{
    if (!_tableView)
    {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:(_tableView = tableView)];
        [self.view setNeedsUpdateConstraints];
    }
    return _tableView;
}


@end
