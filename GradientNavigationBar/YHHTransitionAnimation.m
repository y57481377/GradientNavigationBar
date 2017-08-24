//
//  YHHTransitionAnimation.m
//  GradientNavigationBar
//
//  Created by YANG on 2017/8/19.
//  Copyright © 2017年 洪海 杨. All rights reserved.
//

#import "YHHTransitionAnimation.h"

@implementation YHHTransitionAnimation {
    id<UIViewControllerContextTransitioning> _transitionContext;
    UIView *_toView;
    UIView *_fromView;

    CATransform3D _toTranslation;
    CATransform3D _fromTranslation;
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    _transitionContext = transitionContext;
    _toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    _fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [transitionContext.containerView insertSubview:_toView atIndex:0];
    
    _toTranslation = CATransform3DMakeTranslation(0, -667*0.33, 0);
    _fromTranslation = CATransform3DMakeTranslation(0, 667, 0);
    NSLog(@"动画响应");
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    [super updateInteractiveTransition:percentComplete];
    CATransform3D toTranslation = CATransform3DMakeTranslation(_toTranslation.m41 * (1-percentComplete), _toTranslation.m42 * (1-percentComplete), _toTranslation.m43 * (1-percentComplete));
    CATransform3D fromTranslation = CATransform3DMakeTranslation(_fromTranslation.m41 * percentComplete, _fromTranslation.m42 * percentComplete, _fromTranslation.m43 * percentComplete);
    
    NSLog(@"%f",_fromTranslation.m42);
    
    _toView.layer.transform = toTranslation;
    _fromView.layer.transform = fromTranslation;
}

- (void)finishInteractiveTransition {
    [super finishInteractiveTransition];
    [UIView animateWithDuration:0.35 * (1-self.percentComplete) delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        _fromView.layer.transform = _fromTranslation;
        _toView.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
        [_transitionContext completeTransition:YES];
        NSLog(@"finish");
    }];
}

- (void)cancelInteractiveTransition {
    [super cancelInteractiveTransition];
    [UIView animateWithDuration:0.35 * self.percentComplete delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        _fromView.layer.transform = CATransform3DIdentity;
        _toView.layer.transform = _toTranslation;
    } completion:^(BOOL finished) {
        [_transitionContext completeTransition:NO];
        NSLog(@"cancel");
    }];
}

- (void)dealloc {
    NSLog(@"动画销毁");
}

@end
