//
//  AppDelegate.m
//  BHOrder
//
//  Created by 王帅广 on 2017/12/6.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import "AppDelegate.h"
#import "BHTabBarViewController.h"
#import "BHNavigationViewController.h"
#import "BHLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [WXApi registerApp:WEIXINAPPID];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    if ([BHUser isLogin]) {
        UIStoryboard *mainStroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BHTabBarViewController *tabbarVC = [mainStroyBoard instantiateInitialViewController];
        self.window.rootViewController = tabbarVC;
    }else{
        BHLoginViewController *loginVC = [[BHLoginViewController alloc] initWithNibName:@"BHLoginViewController" bundle:nil];
        self.window.rootViewController = loginVC;
    }
    [self.window makeKeyAndVisible];
    return YES;
}

//微信代理方法
- (void)onResp:(BaseResp *)resp
{
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if(aresp.errCode== 0 && [aresp.state isEqualToString:WXPacket_State])
    {
        NSString *code = aresp.code;
        [[NSNotificationCenter defaultCenter] postNotificationName:WXGETCODESUCCESS object:nil userInfo:@{@"code":code}];
     }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
