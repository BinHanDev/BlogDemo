//
//  NSFileManager+BH.h
//  BlogDemo
//
//  Created by BinHan on 2016/10/13.
//  Copyright © 2016年 BinHan. All rights reserved.
//


@interface NSFileManager (BH)


/**
 获取文件大小

 @param path 文件路径
 @return 返回文件大小
 */
- (long long)fileSizeAtPath:(NSString *)path;

/**
 获取文件夹大小

 @param path 文件夹路径
 @return 返回文件夹大小
 */
- (long long)folderSizeAtPath:(NSString *)path;

@end
