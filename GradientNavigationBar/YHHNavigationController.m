//
//  YHHNavigationController.m
//  GradientNavigationBar
//
//  Created by YANG on 2017/7/19.
//  Copyright © 2017年 洪海 杨. All rights reserved.
//

#import "YHHNavigationController.h"
#import "YHHNavigationTransition.h"
#import "YHHTransitionAnimation.h"
#import "UINavigationController+GestureBack.h"

#import "NSObject+Runtime.h"


#define Screen_Width [UIScreen mainScreen].bounds.size.width
@interface YHHNavigationController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) YHHNavigationTransition *transition;
@property (nonatomic, strong) YHHTransitionAnimation *interactive;

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *screenEdgePanGesture;
@end

@implementation YHHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSArray *methodArr = [UINavigationController getAllMethods];
//    NSLog(@"%@",methodArr);
    
    self.interactivePopGestureRecognizer.delegate = self;
//    _transition = [[YHHNavigationTransition alloc] init];
    
    self.delegate = self;
//    self.transitioningDelegate = self;
    
    
    self.interactivePopGestureRecognizer.enabled = NO;
    _screenEdgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    _screenEdgePanGesture.edges = UIRectEdgeLeft;
    _screenEdgePanGesture.delegate = self;
    [self.view addGestureRecognizer:_screenEdgePanGesture];
}

- (void)panView:(UIPanGestureRecognizer *)pan {
    CGFloat xTranslation = [pan translationInView:self.view].x - 20;
    CGFloat xVelocity = [pan velocityInView:pan.view].x;
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.interactive = [[YHHTransitionAnimation alloc] init];
        [self popViewControllerAnimated:YES];
        NSLog(@"手势开始");
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        // 设置一个起触点，防止误触。
        if (xTranslation > 0) {
            [self.interactive updateInteractiveTransition:(xTranslation + 10)/Screen_Width];
        }
//        NSLog(@"%f",xTranslation);
    }else if (pan.state == UIGestureRecognizerStateEnded) {
        // 设置阻力加速度f，通过速度与阻力作出最终位置的预测
        CGFloat f = 2.0;
        CGFloat preXTranslation = (xTranslation + 10) + (0.5 * xVelocity / f);
        
        if (preXTranslation >= 375 * 0.5) {
            [self.interactive finishInteractiveTransition];
        }else {
            [self.interactive cancelInteractiveTransition];
        }
//        self.interactive = nil;
        NSLog(@"手势结束");
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    // 标记是侧滑返回
    self.isGestureBack = YES;
    return YES;
}


#pragma mark UINavigationControllerDelegate
//通过push/pop方法跳转界面调用该协议方法
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    self.transition.isPop = (operation == UINavigationControllerOperationPop);
    return self.transition;
}

//通过交互手势(侧滑返回)返回调用该协议方法
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController{
    return self.interactive;
}

- (YHHNavigationTransition *)transition {
    if (!_transition) {
        _transition = [[YHHNavigationTransition alloc] init];
    }
    return _transition;
}

//- (YHHTransitionAnimation *)interactive {
//    if (!_interactive) {
//        _interactive = [[YHHTransitionAnimation alloc] init];
//    }
//    return _interactive;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
