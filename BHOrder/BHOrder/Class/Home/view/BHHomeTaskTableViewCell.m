//
//  BHHomeTaskTableViewCell.m
//  BHOrder
//
//  Created by 王帅广 on 2017/12/12.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import "BHHomeTaskTableViewCell.h"
#import "BHTools.h"

@interface BHHomeTaskTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (IBAction)clickSelectButton:(id)sender;

@end

@implementation BHHomeTaskTableViewCell

- (void)setTask:(BHTask *)task{
    _task = task;
    
    self.nameLabel.text = [BHTools taskByType:task.type];
    self.introduceLabel.text = task.taskName;
    self.timeLabel.text = [NSDate timeWithDateFormatter:@"MM-dd" timeNum:task.createTime];
}

- (void)setSelect:(BOOL)select{
    _select = select;
    if (select) {
        [self.selectButton setImage:[UIImage imageNamed:@"home_selected"] forState:UIControlStateNormal];
    }else{
        [self.selectButton setImage:[UIImage imageNamed:@"home_select"] forState:UIControlStateNormal];
    }
}

- (IBAction)clickSelectButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickSelectButtonWithTask:)]) {
        [self.delegate clickSelectButtonWithTask:_task];
    }
}
@end
