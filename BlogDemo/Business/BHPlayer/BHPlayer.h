//
//  BHPlayer.h
//  BlogDemo
//
//  Created by HanBin on 15/5/9.
//  Copyright © 2016年 BinHan. All rights reserved.
//
//  http://binhan1029.github.io/2015/08/15/%E5%B0%81%E8%A3%85AVPlayer-%E5%8C%85%E5%90%AB%E8%A7%A6%E6%91%B8%E6%BB%91%E5%8A%A8%E5%BF%AB%E8%BF%9B-%E5%BF%AB%E9%80%80-%E8%B0%83%E8%8A%82%E9%9F%B3%E9%87%8F-%E5%8F%8A%E7%9B%B8%E5%85%B3%E6%B3%A8%E6%84%8F%E7%82%B9/
//

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

/**
 点击返会按钮的block
 */
@property (nonatomic, copy) dispatch_block_t goBackBlock;

/**
 *  播放
 */
- (void)play;

/**
 * 暂停
 */
- (void)pause;

/**
 重置状态，页面退出必须调用
 */
- (void)resetPlayer;

@end
