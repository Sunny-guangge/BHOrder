//
//  BHTools.h
//  BHOrder
//
//  Created by 王帅广 on 2017/12/11.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHTools : NSObject

#pragma mark - 手机信息的工具方法
/**
 获取手机型号
 
 @return 返回手机型号 例如：iPhone 6s plus
 */
+ (NSString *)deviceMessage;


/**
 获取当前APP版本号
 
 @return 版本号
 */
+ (NSString *)currentAppVersion;

//获取当前controller
+ (UIViewController *)getCurrentVC;

#pragma mark - 任务工具
+ (NSString *)taskByType:(NSInteger)type;

@end
