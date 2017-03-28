//
//  BHListCell.m
//  BlogDemo
//
//  Created by BinHan on 2016/5/27.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHListCell.h"
#import "BHVideoModel.h"

@interface BHListCell ()

/**
 缩略图
 */
@property (nonatomic, weak) UIImageView *vpicView;

/**
 标题
 */
@property (nonatomic, weak) UILabel *shortTitleLable;

/**
 简介
 */
@property (nonatomic, weak) UILabel *vtLable;

@end

@implementation BHListCell

+(NSString *)identifier
{
     return [NSString stringWithUTF8String:object_getClassName([self class])];
}

+(BOOL)requiresConstraintBasedLayout
{
    return YES;
}

#pragma mark - Intial Methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self bind];
    }
    return self;
}

-(void)updateConstraints
{
    [self.vpicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.contentView).offset(10.f);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10.f);
        make.width.mas_equalTo(self.vpicView.mas_height).multipliedBy(11.f/7.f);
    }];
    [self.shortTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.vpicView.mas_right).offset(10.f);
        make.top.mas_equalTo(self.vpicView.mas_top);
    }];
    [self.vtLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.vpicView.mas_right).offset(10.f);
        make.top.mas_equalTo(self.shortTitleLable.mas_bottom).offset(5.f);
    }];
    
    [super updateConstraints];
}

#pragma mark - Private Method

- (void)bind
{
    @weakify(self)
    [[RACObserve(self, modle) distinctUntilChanged] subscribeNext:^(BHVideoModel *model) {
        @strongify(self)
        [self.vpicView sd_setImageWithURL:[NSURL URLWithString:model.vpic]];
        self.shortTitleLable.text = model.shortTitle;
        self.vtLable.text = model.vt;
    }];
}

#pragma mark - Setter Getter Methods

-(UIImageView *)vpicView
{
    if (!_vpicView)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_vpicView = imageView];
    }
    return _vpicView;
}

-(UILabel *)shortTitleLable
{
    if (!_shortTitleLable)
    {
        UILabel *lable = [[UILabel alloc] init];
        lable.font = [UIFont systemFontOfSize:14.f];
        [self.contentView addSubview:_shortTitleLable = lable];
    }
    return _shortTitleLable;
}

-(UILabel *)vtLable
{
    if (!_vtLable)
    {
        UILabel *lable = [[UILabel alloc] init];
        lable.font = [UIFont systemFontOfSize:16.f];
        [self.contentView addSubview:_vtLable = lable];
    }
    return _vtLable;
}

@end
