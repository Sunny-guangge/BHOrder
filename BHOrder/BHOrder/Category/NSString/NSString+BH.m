//
//  NSString+BH.m
//  BHOrder
//
//  Created by 王帅广 on 2017/12/11.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import "NSString+BH.h"

@implementation NSString (BH)

#pragma mark 清空字符串中的空白字符
- (NSString *)trimString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark 是否空字符串
- (BOOL)isEmptyString
{
    return (self.length == 0);
}

- (BOOL)isBlankString {
    if (self == nil || self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    if ([self isEqualToString:@"NULL"] || [self isEqualToString:@"nil"] || [self isEqualToString:@"null"] || [self isEqualToString:@"Null"]) {
        return YES;
    }
    
    return NO;
}

@end
