//
//  ZOAlbumCell.h
//  ttest
//
//  Created by JXMac on 16/12/13.
//  Copyright © 2016年 JXMac. All rights reserved.
//

#import <Photos/Photos.h>

FOUNDATION_EXTERN CGFloat const CellWitdh;

@interface BHAlbumCell : UICollectionViewCell

/**
 当前的ViewModel
 */
@property (nonatomic, strong) PHAsset *assetModel;

/**
 *  获取Cell的identifier
 *
 *  @return cell的identifier
 */
+(NSString *)identifier;

@end
