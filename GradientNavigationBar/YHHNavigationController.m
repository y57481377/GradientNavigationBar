//
//  YHHNavigationController.m
//  GradientNavigationBar
//
//  Created by YANG on 2017/7/19.
//  Copyright © 2017年 洪海 杨. All rights reserved.
//

#import "YHHNavigationController.h"
#import "UINavigationController+GestureBack.h"

#import "NSObject+Runtime.h"

@interface YHHNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation YHHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSArray *methodArr = [UINavigationController getAllMethods];
//    NSLog(@"%@",methodArr);
    self.interactivePopGestureRecognizer.delegate = self;
}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//}
//- (void)back {
//    [self popViewControllerAnimated:YES];
//}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    // 标记是侧滑返回
    self.isGestureBack = YES;
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
