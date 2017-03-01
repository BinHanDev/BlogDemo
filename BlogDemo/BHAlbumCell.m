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
@property (nonatomic, strong) UIImageView *albumImgView;

@end

@implementation BHAlbumCell

+(NSString *)identifier
{
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self bindViewModel];
        [self addSubviews];
        [self setNeedsUpdateConstraints];
        [self updateConstraints];
    }
    return self;
}

/**
 绑定model  判断是视频还是照片  隐藏/显示播放图片及时间Lable
 */
- (void)bindViewModel
{
    @weakify(self)
    [RACObserve(self, assetModel) subscribeNext:^(PHAsset *asset) {
        @strongify(self)
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.networkAccessAllowed = YES;
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(SCREEN_WIDTH / 2.0f, SCREEN_HEIGHT / 2.0f) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.albumImgView.image = result;
        }];
    }];
}

- (void)addSubviews
{
    [self.contentView addSubview:self.albumImgView];
}

-(void)updateConstraints
{
    [self.albumImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(2, 2, 2, 2));
    }];
   [super updateConstraints];
}

- (UIImageView *)albumImgView
{
    if (!_albumImgView)
    {
        _albumImgView = [[UIImageView alloc] init];
        _albumImgView.contentMode = UIViewContentModeScaleAspectFill;
        _albumImgView.layer.masksToBounds = YES;
    }
    return _albumImgView;
}


@end
