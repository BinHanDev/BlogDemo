//
//  BHInputTextDelegate.m
//  BlogDemo
//
//  Created by HanBin on 16/8/14.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHInputTextDelegate.h"

@interface BHInputTextDelegate()

@property (nonatomic, assign)NSInteger limitLength;

@property (nonatomic, copy)LimitBlock limitBlock;

@end

@implementation BHInputTextDelegate

#pragma mark -creat instance

+(instancetype)creatDelegateWithLimitLength:(NSInteger)limitLength  limitBlock:(LimitBlock)limitBlock
{
    return [[[self class] alloc] initLimitLength:limitLength limitBlock:limitBlock];
}

-(instancetype)initLimitLength:(NSInteger)limitLength limitBlock:(LimitBlock)limitBlock

{
    self = [super init];
    if (self)
    {
        self.limitLength = limitLength;
        self.limitBlock = limitBlock;
    }
    return self;
}

#pragma mark -UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length > self.limitLength)
    {
        textField.text = [textField.text substringToIndex:self.limitLength];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *textStr;
    if ([BHUtils isBlankString:string])
    {
        if (textField.text.length != 0)
        {
            textStr = [textField.text substringWithRange:NSMakeRange(0, textField.text.length - 1)];
        }
    }
    else
    {
        textStr = [textField.text stringByAppendingString:string];
    }
    return [self checkLength:textStr range:range replacementString:string];
}

#pragma mark -UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length > self.limitLength)
    {
        textView.text = [textView.text substringToIndex:self.limitLength];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string
{
    NSString *textStr;
    if ([BHUtils isBlankString:string])
    {
        if (textView.text.length != 0)
        {
            textStr = [textView.text substringWithRange:NSMakeRange(0, textView.text.length - 1)];
        }
    }
    else
    {
        textStr = [textView.text stringByAppendingString:string];
    }
    
    return [self checkLength:textStr range:range replacementString:string];
}

#pragma mark -check length

/**
 检查匹配条件

 @param textStr 输入的内容
 @param range   改变的长度
 @param string  增加的内容

 @return 返回结果
 */
-(BOOL)checkLength:(NSString *)textStr range:(NSRange)range replacementString:(NSString *)string
{
    NSInteger existedLength = [self convertToInt:textStr];
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > self.limitLength)
    {
        if (self.limitBlock)
        {
            self.limitBlock();
        }
        return NO;
    }
    else
    {
        return YES;
    }
}

/**
 计算字符串长度

 @param strtemp <#strtemp description#>

 @return 返回长度
 */
-  (NSInteger)convertToInt:(NSString*)strtemp
{
    NSInteger strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p)
        {
            p++;
            strlength++;
        }
        else
        {
            p++;
        }
    }
    return strlength;
}

@end
