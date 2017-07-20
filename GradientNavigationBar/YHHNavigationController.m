//
//  YHHNavigationController.m
//  GradientNavigationBar
//
//  Created by YANG on 2017/7/19.
//  Copyright © 2017年 洪海 杨. All rights reserved.
//

#import "YHHNavigationController.h"
#import "UINavigationController+GestureBack.h"
#import "UIViewController+alpha.h"
#import "NSObject+Runtime.h"

@interface YHHNavigationController ()

@end

@implementation YHHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSArray *methodArr = [self.superclass getAllMethods];
    NSLog(@"%@",methodArr);
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self setNavigationBarAlpha:viewController.navAlpha];
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *vc = [super popViewControllerAnimated:animated];
    [self setNavigationBarAlpha:vc.navAlpha];
    return vc;
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    return [super popToViewController:viewController animated:animated];
}

- (void)setNavigationBarAlpha:(CGFloat)alpha {
    UIView *backView = self.navigationBar.subviews[0];
    
    UIView *shadow = [backView valueForKey:@"_shadowView"];
    if (shadow) {
        shadow.alpha = alpha;
    }
    
    UIView *effectView = [backView valueForKey:@"_backgroundEffectView"];
    if (effectView) {
        effectView.alpha = alpha;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
