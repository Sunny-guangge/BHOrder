//
//  BHScheduleTableViewCell.m
//  BHOrder
//
//  Created by 王帅广 on 2017/12/12.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import "BHScheduleTableViewCell.h"
#import "BHSchedule.h"

@interface BHScheduleTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *hiddenView;

@end

@implementation BHScheduleTableViewCell

- (void)setHidden:(BOOL)hidden{
    _hidden = hidden;
    self.hiddenView.hidden = hidden;
    self.startTimeLabel.hidden = !hidden;
    self.contentLabel.hidden = !hidden;
    self.endTimeLabel.hidden = !hidden;
}

- (void)setSchedule:(BHSchedule *)schedule{
    _schedule = schedule;
    self.startTimeLabel.text = [NSDate timeWithDateFormatter:@"HH:mm" timeNum:schedule.startTime];
    if ([[NSDate timeWithDateFormatter:@"yyyy-MM-dd" timeNum:schedule.endTime] isEqualToString:[NSDate timeWithDateFormatter:@"yyyy-MM-dd" date:[NSDate date]]] ) {
        self.endTimeLabel.text = [NSDate timeWithDateFormatter:@"HH:mm" timeNum:schedule.endTime];
    }else{
        self.endTimeLabel.text = [NSDate timeWithDateFormatter:@"MM-dd HH:mm" timeNum:schedule.endTime];
    }
    self.contentLabel.text = schedule.workName;
}

@end
