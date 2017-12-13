//
//  BHHeaderIconView.h
//  BHOrder
//
//  Created by 王帅广 on 2017/12/13.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickBlock)(void);

@interface BHHeaderIconView : UIView

@property (nonatomic,copy) clickBlock block;

@end
