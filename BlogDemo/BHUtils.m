//
//  BHUtils.m
//  SportZone
//
//  Created by BinHan on 15/3/19.
//  Copyright (c) 2015年 BinHan. All rights reserved.

#import "AppDelegate.h"
#import <objc/runtime.h>

double const kNavBarHeight = 64.f;

@implementation BHUtils

+(NSString *)randFileName
{
    // 获取系统时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyMMddHHmmssSSSSSS"];
    // 时间字符串
    NSString *datestr = [dateFormatter stringFromDate:[NSDate date]];
    // 随机5位字符串
    NSMutableString *randstr = [[NSMutableString alloc]init];
    for(int i = 0 ; i < 5 ; i++)
    {
        int val= arc4random()%10;
        [randstr appendString:[NSString stringWithFormat:@"%d",val]];
    }
    // 生成文件名
    NSString *string = [NSString stringWithFormat:@"F%@%@",datestr,randstr];
    return string;
}

+(BOOL)getVariableWithClass:(Class)myClass varName:(NSString *)varName
{
    unsigned int outCount, i;
    Ivar *ivars = class_copyIvarList(myClass, &outCount);
    if (ivars)
    {
        for (i = 0; i < outCount; i++)
        {
            Ivar property = ivars[i];
            if (property)
            {
                const char *type = ivar_getTypeEncoding(property);
                NSString *stringType = [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
                if (![stringType hasPrefix:@"@"])
                {
                    continue;
                }
                NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
                keyName = [keyName stringByReplacingOccurrencesOfString:@"_" withString:@""];
                if ([keyName isEqualToString:varName])
                {
                    return YES;
                }
            }
        }
    }
    return NO;
}

@end
