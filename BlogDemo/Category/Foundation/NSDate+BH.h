//
//  NSData+BHNSData.h
//  BlogDemo
//
//  Created by HanBin on 2015/10/29.
//  Copyright © 2015年 BinHan. All rights reserved.
//

#define SECOND	(1)
#define MINUTE	(60 * SECOND)
#define HOUR	(60 * MINUTE)
#define DAY		(24 * HOUR)
#define MONTH	(30 * DAY)
#define YEAR	(12 * MONTH)

@interface NSDate (BH)

/**
 获取年份
 */
@property (nonatomic, readonly) NSInteger	year;

/**
 获取月份
 */
@property (nonatomic, readonly) NSInteger	month;

/**
 获取日期
 */
@property (nonatomic, readonly) NSInteger	day;

/**
 获取时间
 */
@property (nonatomic, readonly) NSInteger	hour;

/**
 获取分钟
 */
@property (nonatomic, readonly) NSInteger	minute;

/**
 获取秒
 */
@property (nonatomic, readonly) NSInteger	second;

/**
 获取星期 数字NSInteger类型
 */
@property (nonatomic, readonly) NSInteger	weekday;

/**
 判断两个日期是否在同一周

 @param date 对比的时间
 @return 返回结果
 */
- (BOOL)isSameDateWithDate:(NSDate *)date;

/**
 获取昨天日期

 @return 返回NSDate昨天
 */
- (NSDate*)firstTime;

/**
 获取明天日期
 
 @return 返回NSDate明天
 */
- (NSDate*)lastTime;

/**
 获取星期

 @return 返回星期  是NSString类型
 */
- (NSString*)weekdayStr;

/**
 格式化日期

 @param format NSString类型日期
 @return 返回NSDate时间
 */
+ (NSDate*)dateWithFormat:(NSString *)format;

@end
