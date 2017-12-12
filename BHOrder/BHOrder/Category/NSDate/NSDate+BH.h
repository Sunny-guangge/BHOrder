//
//  NSDate+BH.h
//  BHBaiXiang
//
//  Created by 王帅广 on 2017/3/24.
//  Copyright © 2017年 yyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (BH)

/**
 根据时间编码 和 时间格式 转换成时间格式字符串
 */
+ (NSString *)timeWithDateFormatter:(NSString *)formatter timeNum:(NSString *)timeNum;

/**
 NSDate转换成字符串格式
 */
+ (NSString *)timeWithDateFormatter:(NSString *)formatter date:(NSDate *)date;

@end
