//
//  YHHNavigationTransition.m
//  GradientNavigationBar
//
//  Created by YANG on 2017/8/19.
//  Copyright © 2017年 洪海 杨. All rights reserved.
//

#import "YHHNavigationTransition.h"
#import "YHHTransitionAnimation.h"

@interface YHHNavigationTransition()

//@property (nonatomic, strong) YHHTransitionAnimation *transition;

@end

@implementation YHHNavigationTransition

#pragma mark UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    //需要完成的动画在这里对fromView和toView作用即可完成push／pop自定义动画。
    //这里写的动画以是push动画。
    CATransform3D toTranslation = CATransform3DMakeRotation(M_PI_2, 0, 0, 1);;
    CATransform3D fromTranslation = CATransform3DIdentity;//CATransform3DMakeTranslation(-375 * 0.33, 0, 0);
    
    //判断是否为pop，如果是pop需要把toView加在fromView的下面，如果是push则把toView加在fromView的上面
    NSLog(@"position:%@, anchorPoint:%@", NSStringFromCGPoint(fromView.layer.position), NSStringFromCGPoint(fromView.layer.anchorPoint));
    if (self.isPop) {
        [transitionContext.containerView insertSubview:toView atIndex:0];
        fromView.layer.anchorPoint = CGPointMake(1, 1);
        fromView.layer.position = CGPointMake(fromView.bounds.size.width, fromView.bounds.size.height);
        
        //pop动画与push动画相反，交换toTransition/fromTransition即可做到
        CATransform3D exchange = toTranslation;
        toTranslation = fromTranslation;
        fromTranslation = exchange;
    }else {
        [transitionContext.containerView addSubview:toView];
        toView.layer.anchorPoint = CGPointMake(1, 1);
        toView.layer.position = CGPointMake(toView.bounds.size.width, toView.bounds.size.height);
    }
    
    //如果不清楚fromView和toView具体是哪个，可以设置背景色观察
    toView.layer.transform = toTranslation;
//    fromView.backgroundColor = [UIColor cyanColor];
    

    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            fromView.layer.transform = fromTranslation;
            toView.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
        fromView.layer.transform = CATransform3DIdentity;
        
        fromView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        toView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        fromView.layer.position = CGPointMake(fromView.bounds.size.width/2, fromView.bounds.size.height/2);
        toView.layer.position = CGPointMake(toView.bounds.size.width/2, toView.bounds.size.height/2);
//        fromView.backgroundColor = [UIColor whiteColor];
    }];
}

@end
