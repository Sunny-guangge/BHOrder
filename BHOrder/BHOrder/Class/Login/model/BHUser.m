//
//  BHUser.m
//  BHOrder
//
//  Created by 王帅广 on 2017/12/11.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import "BHUser.h"
#import "AppDelegate.h"
#import "BHLoginViewController.h"

#define UserStorePath ([[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"UserInfo"])

@implementation BHUser

static BHUser *currentUser = nil;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        NSArray *propertyNames = [self allPropertyNames];
        for(NSString *key in propertyNames) {
            id value = [aDecoder decodeObjectForKey:key];
            if (!value) {
                value = @"";
            }
            [self setValue:value forKey:key];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSArray *propertyNames = [self allPropertyNames];
    for(NSString *key in propertyNames) {
        id value = [self valueForKey:key];
        if (!value) {
            value = @"";
        }
        [aCoder encodeObject:value forKey:key];
    }
}

- (NSArray *)allPropertyNames {
    NSMutableArray *names = [[NSMutableArray alloc] init];
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++)
    {
        //get property name
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        [names addObject:name];
    }
    free(properties);
    return names;
}

+ (BHUser *)currentUser{
    if (currentUser == nil) {
        if([[NSFileManager defaultManager] fileExistsAtPath:UserStorePath]) {
            currentUser = [NSKeyedUnarchiver unarchiveObjectWithFile:UserStorePath];
        }
        
        if (currentUser == nil) {
            currentUser = [[BHUser alloc] init];
        }
    }
    return currentUser;
}

+ (BOOL)updateUser{
    if (!currentUser) {
        return NO;
    }
    if (!currentUser.id || currentUser.id.length == 0) {
        return NO;
    }
    return [NSKeyedArchiver archiveRootObject:currentUser toFile:UserStorePath];
}

+ (BOOL)isLogin{
    if (!currentUser) {
        currentUser = [BHUser currentUser];
    }
    if (!currentUser.id || currentUser.id.length == 0) {
        return NO;
    }else{
        return YES;
    }
}

+ (BOOL)logOut{
    [BHUser clearUser];
    [BHUser exitLogoutVC];
    return YES;
}

+ (void)clearUser{
    currentUser.name = nil;
    currentUser.id = nil;
    currentUser.phone = nil;
    currentUser.email = nil;
    currentUser.avatar = nil;
    currentUser.profession = nil;
    currentUser.sign = nil;
    currentUser.token = nil;
    currentUser.isEnable = 0;
    currentUser.isCreateUser = 0;
    [self updateUser];
}

//退出登录
+ (void)exitLogoutVC{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BHLoginViewController *loginVC = [[BHLoginViewController alloc]initWithNibName:@"BHLoginViewController" bundle:nil];
    [delegate.window setRootViewController:loginVC];
}

+ (void)showOtherLogin{
    if ([BHUser isLogin]) {
        [BHUser clearUser];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的账号已在其他地方登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

@end
