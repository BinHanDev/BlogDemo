//
//  ZOAlbumCell.m
//  ttest
//
//  Created by JXMac on 16/12/13.
//  Copyright © 2016年 JXMac. All rights reserved.
//

#import "BHAlbumCell.h"
#import <Photos/Photos.h>

@interface BHAlbumCell()

/**
 图片视图
 */
@property (nonatomic, weak) UIImageView *albumImgView;

@end

@implementation BHAlbumCell

+(NSString *)identifier
{
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

#pragma mark - Intial Methods

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self bindViewModel];
    }
    return self;
}

-(void)updateConstraints
{
    [self.albumImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(2, 2, 2, 2));
    }];
    [super updateConstraints];
}

#pragma mark - Target Methods

#pragma mark - Private Method

/**
 绑定model  判断是视频还是照片  隐藏/显示播放图片及时间Lable
 */
- (void)bindViewModel
{
    @weakify(self)
    [[RACObserve(self, assetModel) distinctUntilChanged] subscribeNext:^(PHAsset *asset) {
        @strongify(self)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.networkAccessAllowed = YES;
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(SCREEN_WIDTH / 2.0f, SCREEN_HEIGHT / 2.0f) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.albumImgView.image = result;
                });
            }];
        });
    }];
}

-(void)setAssetModel:(PHAsset *)assetModel
{
    _assetModel = assetModel;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    [[PHImageManager defaultManager] requestImageForAsset:_assetModel targetSize:CGSizeMake(SCREEN_WIDTH / 2.0f, SCREEN_HEIGHT / 2.0f) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.albumImgView.image = result;
    }];
    
}

#pragma mark - Setter Getter Methods

- (UIImageView *)albumImgView
{
    if (!_albumImgView)
    {
        UIImageView *albumImgView = [[UIImageView alloc] init];
        albumImgView.contentMode = UIViewContentModeScaleAspectFill;
        albumImgView.layer.masksToBounds = YES;
        [self.contentView addSubview:(_albumImgView = albumImgView)];
    }
    return _albumImgView;
}


#pragma mark - External Delegate

@end
