//
//  BHResponse.h
//  BHBaiXiang
//
//  Created by 王帅广 on 16/9/20.
//  Copyright © 2016年 sunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHResponse : NSObject

/**
 *  文字说明
 */
@property (nonatomic,copy) NSString *msg;

/**
 *  返回数据集合
 */
@property (nonatomic,strong) id obj;

/**
 *  返回状态码
 */
@property (nonatomic,copy) NSString *code;

@property (nonatomic,copy) NSString *log_id;
@property (nonatomic,copy) NSString *error_code;
@property (nonatomic,copy) NSString *error_msg;

@property (nonatomic,copy) NSString *result_num;
@property (nonatomic,strong) NSArray *result;
@property (nonatomic,copy) NSString *ext_info;
@property (nonatomic,copy) NSString *faceliveness;
@property (nonatomic,copy) NSString *access_token;
@property (nonatomic,copy) NSString *error_description;
@end
