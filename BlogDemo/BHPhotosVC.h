//
//  BHPhotosVC.h
//  BlogDemo
//
//  Created by BinHan on 2017/2/28.
//  Copyright © 2017年 BinHan. All rights reserved.
//

@class PHFetchResult;

@interface BHPhotosVC : UIViewController

/**
 相册资源
 */
@property (nonatomic, strong) PHFetchResult *fetchResult;

@end
