//
//  BHTabBarViewController.m
//  BHOrder
//
//  Created by 王帅广 on 2017/12/8.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import "BHTabBarViewController.h"
#import "TransitionAnimation.h"
#import "TransitionController.h"
#import "BHNavigationViewController.h"
#import "BHHomeViewController.h"
#import "BHProjectViewController.h"
#import "BHMessageViewController.h"

@interface BHTabBarViewController ()<UITabBarControllerDelegate>

@property(nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation BHTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    self.selectedIndex = 0;
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    self.tabBar.backgroundColor = [UIColor whiteColor];

    for (int i = 0; i < self.tabBar.items.count; i ++) {
        NSDictionary *dic = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        NSDictionary *selecteddic = @{NSForegroundColorAttributeName: UIColorFromRGB(BHAPPMAINCOLOR)};

        UITabBarItem *item = [self.tabBar.items objectAtIndex:i];
        [item setTitleTextAttributes:dic forState:UIControlStateNormal];
        [item setTitleTextAttributes:selecteddic forState:UIControlStateSelected];
    }
}

- (UIPanGestureRecognizer *)panGestureRecognizer{
    if (_panGestureRecognizer == nil){
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    }
    return _panGestureRecognizer;
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)pan{
    if (self.transitionCoordinator) {
        return;
    }
    
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged){
        [self beginInteractiveTransitionIfPossible:pan];
    }
}

- (void)beginInteractiveTransitionIfPossible:(UIPanGestureRecognizer *)sender{
    CGPoint translation = [sender translationInView:self.view];
    if (translation.x > 0.f && self.selectedIndex > 0) {
        self.selectedIndex --;
    }
    else if (translation.x < 0.f && self.selectedIndex + 1 < self.viewControllers.count) {
        self.selectedIndex ++;
    }
    else {
        if (!CGPointEqualToPoint(translation, CGPointZero)) {
            sender.enabled = NO;
            sender.enabled = YES;
        }
    }
    
    [self.transitionCoordinator animateAlongsideTransitionInView:self.view animation:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if ([context isCancelled] && sender.state == UIGestureRecognizerStateChanged){
            [self beginInteractiveTransitionIfPossible:sender];
        }
    }];
}

- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    // 打开注释 可以屏蔽点击item时的动画效果
    //    if (self.panGestureRecognizer.state == UIGestureRecognizerStateBegan || self.panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
    NSArray *viewControllers = tabBarController.viewControllers;
    if ([viewControllers indexOfObject:toVC] > [viewControllers indexOfObject:fromVC]) {
        return [[TransitionAnimation alloc] initWithTargetEdge:UIRectEdgeLeft];
    }
    else {
        return [[TransitionAnimation alloc] initWithTargetEdge:UIRectEdgeRight];
    }
    //    }
    //    else{
    //        return nil;
    //    }
}

- (id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    if (self.panGestureRecognizer.state == UIGestureRecognizerStateBegan || self.panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        return [[TransitionController alloc] initWithGestureRecognizer:self.panGestureRecognizer];
    }
    else {
        return nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
