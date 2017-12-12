//
//  BHHomeTaskTableViewCell.h
//  BHOrder
//
//  Created by 王帅广 on 2017/12/12.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHTask.h"

@protocol BHHomeTaskTableViewCellDeletage <NSObject>

- (void)clickSelectButtonWithTask:(BHTask *)task;

@end

@interface BHHomeTaskTableViewCell : UITableViewCell

@property (nonatomic,strong) BHTask *task;

@property (nonatomic,assign) BOOL select;

@property (nonatomic,weak) id<BHHomeTaskTableViewCellDeletage> delegate;

@end
