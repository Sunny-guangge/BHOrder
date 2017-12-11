//
//  BHViewController.m
//  BHOrder
//
//  Created by 王帅广 on 2017/12/8.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import "BHViewController.h"

@interface BHViewController ()

@end

@implementation BHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
}


- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addCommonBackButton
{
    [self addCommonBackButton:@"home_back"];
}

- (void)addCommonBackButton:(NSString *)imageName {
    
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0, 0, 44, 44);
    [leftBarButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    
    if (FSystemVersion >= 11.0) {
        [leftBarButton setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    }
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    if (!SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceBarButtonItem.width = -15;
        self.navigationItem.leftBarButtonItems = @[spaceBarButtonItem, leftBarButtonItem];
    }
}

- (void)addCommonBackButtonWithTitle:(NSString *)title {
    
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0, 0, 44, 44);
    [leftBarButton setTitle:title forState:UIControlStateNormal];
    leftBarButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftBarButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    if (!SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceBarButtonItem.width = -15;
        self.navigationItem.leftBarButtonItems = @[spaceBarButtonItem, leftBarButtonItem];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
