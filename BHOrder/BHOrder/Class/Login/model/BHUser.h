//
//  BHUser.h
//  BHOrder
//
//  Created by 王帅广 on 2017/12/11.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHUser : NSObject<NSCoding>

/*
 用户id
 */
@property (nonatomic,copy) NSString *id;

/**
 用户姓名
 */
@property (nonatomic,copy) NSString *name;
/**
 手机号
 */
@property (nonatomic,copy) NSString *phone;
/**
 邮箱
 */
@property (nonatomic,copy) NSString *email;
/**
 头像地址
 */
@property (nonatomic,copy) NSString *avatar;
/**
 职业
 */
@property (nonatomic,copy) NSString *profession;
/**
 签名
 */
@property (nonatomic,copy) NSString *sign;
/**
 *token
 */
@property (nonatomic,copy) NSString *token;

/**
 是否禁止登录 0 禁止登录 1 可以登录
 */
@property (nonatomic,assign) BOOL isEnable;
/**
 是否可以管理用户 0 不可以 1 可以
 */
@property (nonatomic,assign) BOOL isCreateUser;

+ (BHUser *)currentUser;

+ (BOOL)updateUser;

+ (BOOL)isLogin;

+ (BOOL)logOut;

+ (void)clearUser;

+ (void)showOtherLogin;

@end
