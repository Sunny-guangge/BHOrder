//
//  NSDate+BH.m
//  BHBaiXiang
//
//  Created by 王帅广 on 2017/3/24.
//  Copyright © 2017年 yyk. All rights reserved.
//

#import "NSDate+BH.h"

@implementation NSDate (BH)

/**
 根据时间编码 和 时间格式 转换成时间格式字符串
 */
+ (NSString *)timeWithDateFormatter:(NSString *)formatter timeNum:(NSString *)timeNum
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeNum doubleValue] / 1000.0];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:formatter];
    return [dateFormatter1 stringFromDate:date];//HH:mm
}

/**
 NSDate转换成字符串格式
 */
+ (NSString *)timeWithDateFormatter:(NSString *)formatter date:(NSDate *)date
{
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:formatter];
    return [dateFormatter1 stringFromDate:date];
}

@end
