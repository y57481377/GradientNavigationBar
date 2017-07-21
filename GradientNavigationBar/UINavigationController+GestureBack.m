//
//  UINavigationController+GestureBack.m
//  GradientNavigationBar
//
//  Created by Yang on 2017/7/20.
//  Copyright © 2017年 洪海 杨. All rights reserved.
//

#import "UINavigationController+GestureBack.h"
#import "NSObject+Runtime.h"
#import <objc/runtime.h>

@implementation UINavigationController (GestureBack)

+ (void)initialize {
    if (self == [UINavigationController class]) {
        // 实现方法交换
        NSArray *arr = @[@"_updateInteractiveTransition:", @"_cancelInteractiveTransition:transitionContext:", @"_finishInteractiveTransition:transitionContext:", @"popViewControllerAnimated:", @"popToViewController:animated:", @"popToRootViewControllerAnimated:"];
        for (int i = 0; i < arr.count; i++) {
            NSString *mySel = [[NSString stringWithFormat:@"yhh_%@", arr[i]] stringByReplacingOccurrencesOfString:@"__" withString:@"_"];
            NSLog(@"%@", mySel);
            Method sysMethod = class_getInstanceMethod([self class], NSSelectorFromString(arr[i]));
            Method myMethod = class_getInstanceMethod([self class], NSSelectorFromString(mySel));
            method_exchangeImplementations(sysMethod, myMethod);
        }
    }
}

#pragma mark --- 侧滑手势事件响应
/**
 侧滑返回实时更新导航栏透明

 @param percentComplete 已滑动距离s与屏幕宽度d的比例(s / d)
 */
- (void)yhh_updateInteractiveTransition:(CGFloat)percentComplete {
    
    UIViewController *topvc = self.topViewController;
    
    id <UIViewControllerTransitionCoordinator> tran = topvc.transitionCoordinator;
    
    UIViewController *fromvc = [tran viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *tovc = [tran viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGFloat alpha = fromvc.navAlpha - (fromvc.navAlpha - tovc.navAlpha) * percentComplete;
    [self setNavigationBarAlpha:alpha];
    [self yhh_updateInteractiveTransition:percentComplete];
}

/**
 侧滑返回手势松手时不能pop回上一界面时调用（滑动小于一半屏幕)

 @param percentComplete 已滑动距离s与屏幕宽度d的比例(s / d)
 @param context 过渡内容
 */
- (void)yhh_cancelInteractiveTransition:(CGFloat)percentComplete transitionContext:(id)context {
    UIViewController *fromvc = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    
//    NSLog(@"%@", [[context superclass] getAllProperties]);
//    NSLog(@"%f-%f--%@", percentComplete, [[context valueForKey:@"_duration"] floatValue], NSStringFromClass([context class]));
    
    CGFloat duration = [[context valueForKey:@"_duration"] floatValue] * percentComplete;
    [self animationWithDuration:duration alpha:fromvc.navAlpha];
    
    [self yhh_cancelInteractiveTransition:percentComplete transitionContext:context];
}

/**
 侧滑返回手势松手时能够pop回上一界面时调用（滑动大于一半屏幕）

 @param percentComplete 已滑动距离s与屏幕宽度d的比例(s / d)
 @param context 过渡内容
 */
- (void)yhh_finishInteractiveTransition:(CGFloat)percentComplete transitionContext:(id)context {
    UIViewController *tovc = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGFloat duration = [[context valueForKey:@"_duration"] floatValue] * (1-percentComplete);
    [self animationWithDuration:duration alpha:tovc.navAlpha];
    
    [self yhh_finishInteractiveTransition:percentComplete transitionContext:context];
}

#pragma mark --- 系统pop事件
- (UIViewController *)yhh_popViewControllerAnimated:(BOOL)animated {
    // self.topViewController与pop方法返回的vc、tovc是同一个
    // 先执行pop方法，topvc.transitionCoordinator 才会有值
    UIViewController *topvc = [self yhh_popViewControllerAnimated:animated];
    [self animationWithDuration:topvc.transitionCoordinator.transitionDuration alpha:topvc.navAlpha];
    
    return topvc;
}

- (NSArray<UIViewController *> *)yhh_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // self.topViewController与参数viewController、tovc是同一个
    // 先执行pop方法，topvc.transitionCoordinator 才会有值
    NSArray *array = [self yhh_popToViewController:viewController animated:animated];
    [self animationWithDuration:viewController.transitionCoordinator.transitionDuration alpha:viewController.navAlpha];
    return array;
}

- (NSArray<UIViewController *> *)yhh_popToRootViewControllerAnimated:(BOOL)animated {
    NSArray *array = [self yhh_popToRootViewControllerAnimated:animated];
    
    UIViewController *topvc = self.topViewController;
    [self animationWithDuration:topvc.transitionCoordinator.transitionDuration alpha:topvc.navAlpha];
    return array;
}


/**
 带动画的前往某一个界面

 @param duration 动画时间
 @param alpha 将要跳转界面导航栏的alpha值
 */
- (void)animationWithDuration:(CGFloat)duration alpha:(CGFloat)alpha {
    [UIView animateWithDuration:duration animations:^{
        [self setNavigationBarAlpha:alpha];
    }];
}


// 设置导航栏的alpha值
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

@end



@implementation UIViewController (alpha)

static NSString *alphaKey = @"alphaKey";
@dynamic navAlpha;

- (CGFloat)navAlpha {
    CGFloat alpha = [objc_getAssociatedObject(self, &alphaKey) floatValue];
    return alpha;
}

- (void)setNavAlpha:(CGFloat)navAlpha {
    objc_setAssociatedObject(self, &alphaKey, @(navAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController setNavigationBarAlpha:navAlpha];
}

@end
