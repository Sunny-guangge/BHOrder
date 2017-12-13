//
//  BHTools.m
//  BHOrder
//
//  Created by 王帅广 on 2017/12/11.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import "BHTools.h"
#import "sys/utsname.h"

@implementation BHTools

#pragma mark - 手机信息的工具方法
+ (NSString *)deviceMessage
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])    return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    
    return deviceString;
}

+ (NSString *)currentAppVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

+ (UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    return result;
}

#pragma mark - 任务工具
+ (NSString *)taskByType:(NSInteger)type{
    NSString *taskType;
    switch (type) {
        case 1:
            taskType = @"调研";
            break;
        case 2:
            taskType = @"投标";
            break;
        case 3:
            taskType = @"立项";
            break;
        case 4:
            taskType = @"谈判";
            break;
        case 5:
            taskType = @"签署协议";
            break;
        case 6:
            taskType = @"拟方案";
            break;
        case 7:
            taskType = @"商讨";
            break;
        case 8:
            taskType = @"内审";
            break;
        case 9:
            taskType = @"法律意见书";
            break;
        case 10:
            taskType = @"发票";
            break;
        case 11:
            taskType = @"报价";
            break;
        case 12:
            taskType = @"付款";
            break;
        case 13:
            taskType = @"归档";
            break;
        case 99:
            taskType = @"其它";
            break;
        default:
            taskType = @"";
            break;
    }
    return taskType;
}

@end
