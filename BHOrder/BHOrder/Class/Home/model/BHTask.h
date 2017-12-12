//
//  BHTask.h
//  BHOrder
//
//  Created by 王帅广 on 2017/12/12.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHTask : NSObject

@property (nonatomic,copy) NSString *assignsIds;
@property (nonatomic,copy) NSString *createBy;
@property (nonatomic,copy) NSString *createTime;//起始时间
@property (nonatomic,copy) NSString *endTime;
@property (nonatomic,copy) NSString *id;//任务id
@property (nonatomic,copy) NSString *level;///优先级 1普通、2紧急
@property (nonatomic,copy) NSString *othersTaskType;
@property (nonatomic,copy) NSString *parentId;//父任务id
@property (nonatomic,copy) NSString *proCreateUser;
@property (nonatomic,copy) NSString *proId;//项目id
@property (nonatomic,copy) NSString *proName;//项目名称
@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,assign) NSInteger status;//任务状态 1：待执行、 2：执行中、 3： 已暂停、4：已完成、 5：已归档、 6：已终止
@property (nonatomic,copy) NSString *taskName;//任务名称
@property (nonatomic,copy) NSString *taskNo;//任务编号
@property (nonatomic,assign) NSInteger type;//任务类型 1调研、2投标、3立项、4谈判、5签署协议、6拟方案、7商讨、8内审、9法律意见书、10发票、11报价、12付款、13归档、99其它

@end
