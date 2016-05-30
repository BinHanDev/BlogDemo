//
//  BHHeaderView.h
//  BlogDemo
//
//  Created by HanBin on 16/5/30.
//  Copyright © 2016年 BinHan. All rights reserved.
//

/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, BHRefreshState) {
    /** 普通闲置状态 */
    BHRefreshStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    BHRefreshStatePulling,
    /** 正在刷新中的状态 */
    BHRefreshStateRefreshing,
    /** 即将刷新的状态 */
    BHRefreshStateWillRefresh,
    /** 所有数据加载完毕，没有更多的数据了 */
    BHRefreshStateNoMoreData
};

@interface BHRefreshHeader : UIView

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end
