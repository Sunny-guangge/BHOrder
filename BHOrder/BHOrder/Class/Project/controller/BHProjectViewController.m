//
//  BHProjectViewController.m
//  BHOrder
//
//  Created by 王帅广 on 2017/12/8.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import "BHProjectViewController.h"
#import "BHPopView.h"
#import "BHHeaderIconView.h"

@interface BHProjectViewController ()

@end

@implementation BHProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"全部项目" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button addTarget:self action:@selector(clickTitleButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = button;
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_create"] style:UIBarButtonItemStyleDone target:self action:@selector(clickaddbutton)];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_search"] style:UIBarButtonItemStyleDone target:self action:@selector(clickSearchButton)];
    self.navigationItem.rightBarButtonItems = @[addItem,searchItem];
    
    BHHeaderIconView *leftItem = [[BHHeaderIconView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    leftItem.block = ^{
        NSLog(@"333333");
    };
    self.navigationItem.leftBarButtonItem = left;
}

- (void)clickaddbutton{
    BHPopView *view = [[BHPopView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds TitleArray:@[@[@"creat_project",@"创建项目"],@[@"creat_task",@"创建任务"],@[@"creat_schedule",@"创建日程"],@[@"home_help",@"帮助"]] textAlignmentType:NSTextAlignmentLeft BHPopViewDirectionType:BHPopViewDirectionDown];
    view.block = ^(NSInteger index) {
        
    };
    [view showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)clickSearchButton{
    
}

- (void)clickTitleButton{
    NSLog(@"==================");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
