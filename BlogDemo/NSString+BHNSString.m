//
//  NSString+BHNSString.m
//  BlogDemo
//
//  Created by HanBin on 2015/10/29.
//  Copyright © 2015年 BinHan. All rights reserved.
//

#import "NSString+BHNSString.h"

@implementation NSString (BHNSString)

- (BOOL)isBlankString
{
    BOOL ret = NO;
    if ((self == nil)|| (self == NULL) || ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) || [self isKindOfClass:[NSNull class]])
    {
        ret = YES;
    }
    return ret;
}

- (BOOL)isNotBlankText
{
    return ![self isBlankString];
}

- (BOOL)isPhoneNumber
{
    if (![self hasPrefix:@"1"])
    {
        return NO;
    }
    NSString * MOBILE = @"^[1-9]\\d{10}$";
    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return  [regextestMobile evaluateWithObject:self];
}

- (BOOL)isTelephones
{
    NSString * MOBILE = @"^[1-9]\\d{7}$";
    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return  [regextestMobile evaluateWithObject:self];
}



@end
