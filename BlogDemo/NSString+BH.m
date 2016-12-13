//
//  NSString+BHNSString.m
//  BlogDemo
//
//  Created by HanBin on 2015/10/29.
//  Copyright © 2015年 BinHan. All rights reserved.
//

#import "NSString+BH.h"

@implementation NSString (BH)

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

- (NSString*)reverseWordsInString
{
    NSMutableString *reverString = [NSMutableString stringWithCapacity:self.length];
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences  usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [reverString appendString:substring];
    }];
    return reverString;
}

- (NSString *)transformToPinYin
{
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [self mutableCopy];
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    NSLog(@"%@", pinyin);
    //去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"%@", pinyin);
    //返回最近结果
    return pinyin;
}

@end
