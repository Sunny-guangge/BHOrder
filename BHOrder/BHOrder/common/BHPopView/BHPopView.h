//
//  BHPopView.h
//  testupview
//
//  Created by 王帅广 on 2017/12/8.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,BHPopViewDirectionType) {
    BHPopViewDirectionUp,
    BHPopViewDirectionDown
};

typedef void(^BHPopViewBlock)(NSInteger index);

@interface BHPopView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                   TitleArray:(NSArray *)array
            textAlignmentType:(NSTextAlignment)textAlignment
       BHPopViewDirectionType:(BHPopViewDirectionType)directionType;
//显示的数据
@property (nonatomic,copy) NSArray *array;

@property (nonatomic,assign) NSTextAlignment textAlignment;

@property (nonatomic,assign) BHPopViewDirectionType directionType;

//选中的文字
@property (nonatomic,copy) NSString *selectTitle;
//选中的文字的颜色
@property (nonatomic,copy) UIColor *selectColor;
//点击选中的block回调
@property (nonatomic,copy) BHPopViewBlock block;

//显示的视图上
- (void)showInView:(UIView *)view;

//隐藏视图
- (void)hide;

@end
