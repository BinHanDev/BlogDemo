//
//  BHCellRandomCell.h
//  BlogDemo
//
//  Created by HanBin on 16/3/9.
//  Copyright © 2016年 BinHan. All rights reserved.
//



@protocol BHCellRandomCellDelegate <NSObject>

-(void)chickItem:(NSString *)str;

@end

@interface BHCellRandomCell : UITableViewCell

@property(nonatomic, weak) NSObject<BHCellRandomCellDelegate> *delegate;
@property(nonatomic, strong) NSArray *dataArr;

/**
 *  cell的identifier
 *
 *  @return 返回identifier
 */
+(NSString *)identifier;

@end
