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
        NSArray *arr = @[@"_updateInteractiveTransition:", @"_cancelInteractiveTransition:transitionContext:", @"_finishInteractiveTransition:transitionContext:"];
        for (int i = 0; i < arr.count; i++) {
            NSString *mySel = [NSString stringWithFormat:@"yhh%@", arr[i]];
            NSLog(@"%@",mySel);
            Method sysMethod = class_getInstanceMethod([self class], NSSelectorFromString(arr[i]));
            Method myMethod = class_getInstanceMethod([self class], NSSelectorFromString(mySel));
            method_exchangeImplementations(sysMethod, myMethod);
        }
    }
}

// 侧滑返回实时更新导航栏透明
- (void)yhh_updateInteractiveTransition:(CGFloat)percentComplete {
//    NSLog(@"%f", percentComplete);
    UIViewController *topvc = self.topViewController;
    
    id <UIViewControllerTransitionCoordinator> tran = topvc.transitionCoordinator;
    
    UIViewController *fromvc = [tran viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *tovc = [tran viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGFloat alpha = fromvc.navAlpha - (fromvc.navAlpha - tovc.navAlpha) * percentComplete;
    [self setNavigationBarAlpha:alpha];
    [self yhh_updateInteractiveTransition:percentComplete];
}

// 侧滑返回手势松手时不能pop回上一界面时调用（滑动小于一半屏幕)
- (void)yhh_cancelInteractiveTransition:(CGFloat)percentComplete transitionContext:(id)context {
    UIViewController *fromvc = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    
//    NSLog(@"%@", [[context superclass] getAllProperties]);
//    NSLog(@"%f-%f--%@", percentComplete, [[context valueForKey:@"_duration"] floatValue], NSStringFromClass([context class]));
    
    [UIView animateWithDuration:[[context valueForKey:@"_duration"] floatValue]*percentComplete animations:^{
        [self setNavigationBarAlpha:fromvc.navAlpha];
    }];
    [self yhh_cancelInteractiveTransition:percentComplete transitionContext:context];
}

// 侧滑返回手势松手时能够pop回上一界面时调用（滑动大于一半屏幕）
- (void)yhh_finishInteractiveTransition:(CGFloat)percentComplete transitionContext:(id)context {
    UIViewController *tovc = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [UIView animateWithDuration:[[context valueForKey:@"_duration"] floatValue] *(1-percentComplete) animations:^{
        [self setNavigationBarAlpha:tovc.navAlpha];
    }];
    [self yhh_finishInteractiveTransition:percentComplete transitionContext:context];
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
