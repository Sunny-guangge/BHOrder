//
//  BHYMBCheckMoreView.h
//  BHBaiXiang
//
//  Created by 王帅广 on 2017/4/20.
//  Copyright © 2017年 yyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHYMBCheckMoreView : UIView

@property (nonatomic, copy) void (^selectRowAtIndex)(NSInteger index);

- (instancetype)initWithPoint:(CGPoint)point titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray;

- (void)show;
- (void)hide;
@end
