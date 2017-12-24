//
//  BHTableView.m
//  BHOrder
//
//  Created by 王帅广 on 2017/12/16.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import "BHTableView.h"

@implementation BHTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return self;
}

@end
