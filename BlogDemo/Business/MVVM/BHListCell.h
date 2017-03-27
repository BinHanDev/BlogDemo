//
//  BHListCell.h
//  BlogDemo
//
//  Created by BinHan on 2016/5/27.
//  Copyright © 2016年 BinHan. All rights reserved.
//

@class BHVideoModel;

@interface BHListCell : UITableViewCell

/**
 model
 */
@property (nonatomic, strong) BHVideoModel *modle;

/**
 cell 的 identifier

 @return 返回 identifier
 */
+(NSString *)identifier;

@end
