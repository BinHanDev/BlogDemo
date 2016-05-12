//
//  BHPlayer.h
//  BlogDemo
//
//  Created by HanBin on 16/5/9.
//  Copyright © 2016年 BinHan. All rights reserved.
//

typedef void (^BHPlayerGoBackBlock)(void);

@interface BHPlayer : UIView

/**
 *  视频地址
 */
@property (nonatomic, copy) NSString *sourceUrl;

/**
 *  可以直接从视频某时间点开始播放
 */
@property (nonatomic, assign) NSInteger seekTime;

/**
 *  视频画面展示model
 */
@property (nonatomic, copy) NSString *playerLayerGravity;

@property (nonatomic, copy) BHPlayerGoBackBlock goBackBlock;

@end
