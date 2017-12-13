//
//  BHYMBCheckMoreView.m
//  BHBaiXiang
//
//  Created by 王帅广 on 2017/4/20.
//  Copyright © 2017年 yyk. All rights reserved.
//

#import "BHYMBCheckMoreView.h"

@interface BHYMBCheckMoreView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIImageView *imageBackView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, assign) CGPoint point;

@end

@implementation BHYMBCheckMoreView

- (instancetype)initWithPoint:(CGPoint)point titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        _titleArray = titleArray;
        _imageArray = imageArray;
        _point = point;
        self.backgroundColor = [UIColor clearColor];
        
        _backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        tap.delegate = self;
        [_backView addGestureRecognizer:tap];
        
        [self setupUinterface];
    }
    return self;
}

- (void)setupUinterface{
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(_point.x - 73, _point.y, 120, _titleArray.count * 40 + 4 + 5)];
    _contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentView];
    
    _imageBackView = [[UIImageView alloc] init];
    _imageBackView.image = [[UIImage imageNamed:@"baihui_ymb_kuang"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 10, 30) resizingMode:UIImageResizingModeTile];
    _imageBackView.backgroundColor = [UIColor clearColor];
    _imageBackView.frame = CGRectMake(0, 0, 120, _titleArray.count * 40 + 4 + 5);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(_imageBackView.originX + 2.5, _imageBackView.originY + 6.5, 80, _titleArray.count * 40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alwaysBounceHorizontal = NO;
    _tableView.alwaysBounceVertical = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = YES;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_contentView addSubview:_imageBackView];
    
    [_contentView addSubview:_tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [_titleArray objectAtIndex:indexPath.row];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont fontWithsize:15];
    nameLabel.textColor = UIColorFromRGB(0x333333);
    [cell.contentView addSubview:nameLabel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectRowAtIndex) {
        self.selectRowAtIndex(indexPath.row);
    }
    [self hide];
}

- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSArray *windowViews = [window subviews];
    if(windowViews && [windowViews count] > 0){
        UIView *subView = [windowViews objectAtIndex:[windowViews count]-1];
        for(UIView *aSubView in subView.subviews)
        {
            [aSubView.layer removeAllAnimations];
        }
        [subView addSubview:self];
        [self showBackground];
        [self showAlertAnimation];
    }
}

- (void)showBackground
{
    _backView.alpha = 0;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.28];
    _backView.alpha = 0.3;
    [UIView commitAnimations];
}

-(void)showAlertAnimation
{
    _contentView.alpha = 0.f;
    _contentView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _contentView.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        _contentView.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _contentView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3f animations:^{
        _contentView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        _contentView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_contentView removeFromSuperview];
    }];
    
    [UIView animateWithDuration:0.35 animations:^{
        _backView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_backView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCell"]) {
        return NO;
    }
    return  YES;
}

@end
