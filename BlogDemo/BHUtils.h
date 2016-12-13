//
//  BHUtils.h
//  SportZone
//
//  Created by BinHan on 15/3/19.
//  Copyright (c) 2015年 BinHan. All rights reserved.
//

#ifdef DEBUG
    #define BHLog(...) NSLog(__VA_ARGS__)
#else
    #define BHLog(...)
#endif

/**
 *  不需要缓存的时候不建议使用
 */
#define BHIMG(str) [UIImage imageNamed:(str)]

#define iOS_VERSION_ABOVE(x) ([[UIDevice currentDevice].systemVersion doubleValue] >= x) // 判断系统

#define YES_OBJ		@1.0
#define NO_OBJ		nil

#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

// 是否模拟器
#define isSimulator (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)

#define kSystemVersion [[UIDevice currentDevice] systemVersion]

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

#define SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)

#define SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

#define iPad ((int)[[UIScreen mainScreen] bounds].size.width==768)

#define iPhone6Plus ((int)[[UIScreen mainScreen] bounds].size.width==414)

#define iPhone6 ((int)[[UIScreen mainScreen] bounds].size.width==375)

#define iPhone ((int)[[UIScreen mainScreen] bounds].size.width==320)

// 获取本地版本号
#define kLocalVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//一些缩写
#define kApplication        [UIApplication sharedApplication]
#define kKeyWindow          [UIApplication sharedApplication].keyWindow
#define kAppDelegate        [UIApplication sharedApplication].delegate
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

//获取沙盒Document路径
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒temp路径
#define kTempPath NSTemporaryDirectory()
//获取沙盒Cache路径
#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

//随机色值
#define kRandomColor  KRGBColor(arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0)

// 弱引用 强引用
#define kWeakSelf(type)   __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;

#define KRATE (SCREEN_WIDTH/320.0)

#define KKRATE(rate) (KRATE > 1 ? KRATE * rate : KRATE)

/**
 *  navigationBar的高度
 */
FOUNDATION_EXTERN double const kNavBarHeight;

@interface BHUtils : NSObject

/**
 *  更具系统当前时间生成随机文件名
 *
 *  @return 返回文件名
 */
+(NSString *)randFileName;

@end
