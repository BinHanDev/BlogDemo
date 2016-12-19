//
//  ZOAlbumCell.m
//  ttest
//
//  Created by JXMac on 16/12/13.
//  Copyright © 2016年 JXMac. All rights reserved.
//

#import "ZOAlbumCell.h"
#import "PHAsset+ZO.h"

@interface ZOAlbumCell()

@property (nonatomic, strong) UILabel *titleLabel;

/**
 图片视图
 */
@property (nonatomic, strong) UIImageView *albumImgView;

/**
 播放图片视图
 */
@property (nonatomic, strong) UIImageView *playImgView;

/**
 对勾视图
 */
@property (nonatomic, strong) UIImageView *checkmarkImageView;

@end

@implementation ZOAlbumCell

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
        if(asset.mediaType == PHAssetMediaTypeVideo)
        {
            self.playImgView.hidden = NO;
        }
        else if(asset.mediaType == PHAssetMediaTypeImage)
        {
            self.playImgView.hidden = YES;
        }
        if (asset.duration == 0)
        {
            self.titleLabel.hidden = YES;
        }
        else
        {
            self.titleLabel.hidden = NO;
            self.titleLabel.text = [self formatSeconds:asset.duration];
        }
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.networkAccessAllowed = YES;
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(kScreenWidth / 2.0f, kScreenWidth / 2.0f) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.albumImgView.image = result;
            asset.albumImage = result;
        }];
        @weakify(self)
        [[RACObserve(asset, isSelected) distinctUntilChanged] subscribeNext:^(id x) {
            @strongify(self)
            self.checkmarkImageView.hidden = ![x boolValue];
        }];
        
    }];
}


/**
 对时间长度进行格式化

 @param value 时长
 @return 返回格式化后字符串
 */
- (NSString *)formatSeconds:(NSInteger)value
{
    NSInteger seconds = value % 60;
    NSInteger minutes = (value / 60) % 60;
    NSInteger hours = (value / 3600);
    if (hours < 1)
    {
        if(minutes == 0)
        {
            return [NSString stringWithFormat:@"0:%02ld",(long)seconds];
        }
        else
        {
            return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
        }
        
    }
    else
    {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
        
    }
}

- (void)addSubviews
{
    [self.contentView addSubview:self.albumImgView];
    [self.contentView addSubview:self.checkmarkImageView];
    [self.contentView addSubview:self.playImgView];
    [self.contentView addSubview:self.titleLabel];
}

-(void)updateConstraints
{
    [self.albumImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(2, 2, 2, 2));
    }];
    [self.checkmarkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10.f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10.f);
        make.width.mas_equalTo(30.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.playImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.height.mas_equalTo(46.f);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(-5.f);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(20.0f);
    }];

   [super updateConstraints];
}

- (UIImageView *)albumImgView
{
    if (!_albumImgView)
    {
        _albumImgView = [[UIImageView alloc] init];
        _albumImgView.image = ZOIMG(@"moren");
        _albumImgView.contentMode = UIViewContentModeScaleAspectFill;
        _albumImgView.layer.masksToBounds = YES;
    }
    return _albumImgView;
}

- (UIImageView *)playImgView
{
    if (!_playImgView)
    {
        _playImgView = [[UIImageView alloc] init];
        _playImgView.image = ZOIMG(@"shiping");
        _playImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _playImgView;
}

- (UIImageView *)checkmarkImageView
{
    if (!_checkmarkImageView)
    {
        _checkmarkImageView = [[UIImageView alloc] init];
        _checkmarkImageView.image = ZOIMG(@"xuanzhong");
        _playImgView.contentMode = UIViewContentModeScaleToFill;
    }
    return _checkmarkImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"哈哈哈哈哈哈哈哈哈哈哈";
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.font = [UIFont systemFontOfSize:FontOfSize(13.0)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _titleLabel;
}

@end
