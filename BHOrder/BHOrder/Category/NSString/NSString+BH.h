//
//  NSString+BH.h
//  BHOrder
//
//  Created by 王帅广 on 2017/12/11.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BH)

/**
 *  是否空字符串
 *
 *  @return 如果字符串为nil或者长度为0返回YES
 */
- (BOOL)isEmptyString;

/**
 判断字符串是否为空
 
 @return 返回判断结果 YES 表示是空字符串  NO 表示不是
 */
- (BOOL)isBlankString;

/**
 *  清空字符串中的空白字符
 *
 *  @return 清空空白字符串之后的字符串
 */
- (NSString *)trimString;

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;

@end
