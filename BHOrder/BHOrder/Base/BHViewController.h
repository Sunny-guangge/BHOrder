//
//  BHViewController.h
//  BHOrder
//
//  Created by 王帅广 on 2017/12/8.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHViewController : UIViewController

//导航栏添加自定义返回按钮
- (void)addCommonBackButton;
- (void)addCommonBackButton:(NSString *)imageName;
- (void)addCommonBackButtonWithTitle:(NSString *)title;
- (void)popViewController;

/**
 *分页用的page
 */
@property (nonatomic,assign) NSInteger page;

@end
