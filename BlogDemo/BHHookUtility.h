//
//  BHHookUtility.h
//  SportZone
//
//  Created by BinHan on 15/3/19.
//  Copyright (c) 2015年 BinHan. All rights reserved.


@interface BHHookUtility : NSObject

+ (void)swizzlingInClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end
