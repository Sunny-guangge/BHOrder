//
//  BHSchedule.h
//  BHOrder
//
//  Created by 王帅广 on 2017/12/13.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHSchedule : NSObject

@property (nonatomic,copy) NSString *id;//日程id
@property (nonatomic,copy) NSString *proId;//项目id
@property (nonatomic,copy) NSString *workName;//日程名称
@property (nonatomic,copy) NSString *address;//地点
@property (nonatomic,copy) NSString *startTime;//开始时间
@property (nonatomic,copy) NSString *endTime;//结束时间
@property (nonatomic,copy) NSString *repeatType;//重复方式 0 永不 1 每天 2每周 4 每月 5 每年
@property (nonatomic,copy) NSString *memberIds;//参与人员ids，逗号隔开
@property (nonatomic,copy) NSString *remindType;//提醒方式  '0' 无  1 事件发生时 5 5分钟前 10 10分钟前 15 15分钟前30 30 分钟前  60 1小时前 120 2小时前 1440 一天前 2880 两天前  10080 一周前
@property (nonatomic,copy) NSString *remindTime;//提醒时间

@end
