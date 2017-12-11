//
//  BHProjectViewController.m
//  BHOrder
//
//  Created by 王帅广 on 2017/12/8.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import "BHProjectViewController.h"

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
}

- (void)clickTitleButton{
    NSLog(@"==================");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
