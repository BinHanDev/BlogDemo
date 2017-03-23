//
//  BHPhotosCell.h
//  BlogDemo
//
//  Created by HanBin on 2016/2/13.
//  Copyright © 2016年 BinHan. All rights reserved.
//

FOUNDATION_EXTERN CGFloat const rowHeight;

@class PHAssetCollection;

@interface BHPhotosCell : UITableViewCell

/**
 *  获取Cell的identifier
 *
 *  @return cell的identifier
 */
+(NSString *)identifier;

@property (nonatomic, strong) PHAssetCollection *assetCollection;

@end
