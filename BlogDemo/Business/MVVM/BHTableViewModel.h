//
//  BHTableViewModel.h
//  BlogDemo
//
//  Created by BinHan on 2016/5/27.
//  Copyright © 2016年 BinHan. All rights reserved.
//

@interface BHTableViewModel : NSObject

/**
 所搜数据
 */
@property (nonatomic, strong) RACCommand *searchCommand;

/**
 数据集合
 */
@property (nonatomic, strong) NSArray *dataArray;

/**
 是否有数据
 */
@property (nonatomic, assign) BOOL isHasData;

@end
