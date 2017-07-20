//
//  UIViewController+alpha.m
//  GradientNavigationBar
//
//  Created by Yang on 2017/7/20.
//  Copyright © 2017年 洪海 杨. All rights reserved.
//

#import "UIViewController+alpha.h"
#import <objc/runtime.h>
#import "NSObject+Runtime.h"

static NSString *alphaKey = @"alphaKey";

@implementation UIViewController (alpha)

@dynamic navAlpha;

- (CGFloat)navAlpha {
    CGFloat alpha = [objc_getAssociatedObject(self, &alphaKey) floatValue];
    return alpha;
}

- (void)setNavAlpha:(CGFloat)navAlpha {
    objc_setAssociatedObject(self, &alphaKey, @(navAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNavigationBarAlpha:navAlpha];
}

- (void)setNavigationBarAlpha:(CGFloat)alpha {
    UIView *backView = self.navigationController.navigationBar.subviews[0];
    
//    NSArray *properties = [[self.navigationController.navigationBar.subviews[0] class] getAllIvars];
//    NSLog(@"%@", properties);
    
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
