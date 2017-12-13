//
//  BHScheduleTableViewCell.h
//  BHOrder
//
//  Created by 王帅广 on 2017/12/12.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BHSchedule;
@interface BHScheduleTableViewCell : UITableViewCell

@property (nonatomic,assign) BOOL hidden;

@property (nonatomic,strong) BHSchedule *schedule;

@end
