//
//  BHPhotosCell.m
//  BlogDemo
//
//  Created by HanBin on 2016/2/13.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHPhotosCell.h"
#import <Photos/Photos.h>

CGFloat const rowHeight = 58.f;

@interface BHPhotosCell()

/**
 缩略图
 */
@property (nonatomic, weak) UIImageView *photoImageView;

/**
 相册名称
 */
@property (nonatomic, weak) UILabel *photosNameLable;

@end

@implementation BHPhotosCell

+(NSString *)identifier
{
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.photoImageView];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self bindModel];
    }
    return self;
}

#pragma mark - Intial Methods

#pragma mark - Target Methods

#pragma mark - Private Method

-(void)bindModel
{
    @weakify(self)
    [[RACObserve(self, assetCollection) distinctUntilChanged] subscribeNext:^(PHAssetCollection *assetCollection) {
        @strongify(self)
        self.photosNameLable.text = assetCollection.localizedTitle;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            if (fetchResult.lastObject) {
                PHAsset *asset = fetchResult.lastObject;
                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    self.photoImageView.image = [UIImage imageWithData:imageData];
                    self.photosNameLable.text = [assetCollection.localizedTitle stringByAppendingFormat:@"  (%ld)", fetchResult.count];
                }];
            }
        });
        
    }];
}


#pragma mark - Setter Getter Methods

-(UIImageView *)photoImageView
{
    if (!_photoImageView)
    {
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = [UIColor redColor];
        imageView.frame = CGRectMake(0, 0, rowHeight, rowHeight);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:(_photoImageView = imageView)];
    }
    return _photoImageView;
}

-(UILabel *)photosNameLable
{
    if (!_photosNameLable)
    {
        UILabel *lable = [UILabel new];
        lable.frame = CGRectMake(rowHeight + 10.f, 0, SCREEN_WIDTH - rowHeight, rowHeight);
        [self.contentView addSubview:(_photosNameLable = lable)];
    }
    return _photosNameLable;
}

#pragma mark - External Delegate



@end
