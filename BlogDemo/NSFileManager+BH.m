//
//  NSFileManager+BH.m
//  BlogDemo
//
//  Created by BinHan on 2016/10/13.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "NSFileManager+BH.h"

@implementation NSFileManager (BH)

- (long long)fileSizeAtPath:(NSString *)path
{
    if ([self fileExistsAtPath:path])
    {
        long long size = [self attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}

- (long long)folderSizeAtPath:(NSString *)path
{
    long long folderSize = 0;
    if ([self fileExistsAtPath:path])
    {
        NSArray *childerFiles = [self subpathsAtPath:path];
        for (NSString *fileName in childerFiles)
        {
            NSString *fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
            if ([self fileExistsAtPath:fileAbsolutePath])
            {
                long long size = [self attributesOfItemAtPath:fileAbsolutePath error:nil].fileSize;
                folderSize += size;
            }
        }
    }
    return folderSize;
}

@end
