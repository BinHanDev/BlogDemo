//
//  BHHookUtility.h
//  SportZone
//
//  Created by BinHan on 15/3/19.
//  Copyright (c) 2015年 BinHan. All rights reserved.
//
//  hook工具类
//

@interface BHHookUtility : NSObject


/**
 交换两个方法

 @param cls 当前class
 @param originalSelector originalSelector description
 @param swizzledSelector swizzledSelector description
 @return 返回
 */
+ (BOOL)swizzlingInClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end
