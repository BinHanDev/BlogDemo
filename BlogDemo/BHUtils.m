//
//  BHUtils.m
//  SportZone
//
//  Created by BinHan on 15/3/19.
//  Copyright (c) 2015年 BinHan. All rights reserved.

#import "AppDelegate.h"
#import "MBProgressHUD.h"

double const kNavBarHeight = 64.f;

@implementation BHUtils

+ (void)showMessage:(NSString *)message
{
    UIWindow *window = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.margin = 15.f;
    hud.yOffset = 15.f;
    //小矩形的背景色
    hud.color = [[UIColor blackColor] colorWithAlphaComponent:0.8f];//这儿表示无背景
    //显示的文字
    hud.labelText = message;
    hud.dimBackground = NO;
    hud.userInteractionEnabled = NO;
    [hud hide:YES afterDelay:1.5f];
}

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

+ (NSString *)contentTypeForImageData:(NSData *)data
{
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c)
    {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12)
            {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"])
            {
                return @"webp";
            }
            return nil;
    }
    return nil;
}

//static __inline__ CGFloat CGPointDistanceBetweenTwoPoints(CGPoint point1, CGPoint point2)
//{
//    CGFloat dx = point2.x - point1.x;
//    CGFloat dy = point2.y - point1.y;
//    return sqrt(dx*dx + dy*dy);
//}

@end
