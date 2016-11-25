//
//  NSString+BHNSString.h
//  BlogDemo
//
//  Created by HanBin on 2015/10/29.
//  Copyright © 2015年 BinHan. All rights reserved.
//

@interface NSString (BH)

/**
 @return 返回字符串是否为空
 */
- (BOOL)isBlankString;

/**
 @return 返回字符串是否为空
 */
- (BOOL)isNotBlankText;

/**
 @return 返回字符串是否为手机号码(11位)
 */
- (BOOL)isPhoneNumber;

/**
 @return 返回字符串是否为座机号码(7位)
 */
- (BOOL)isTelephones;

@end
