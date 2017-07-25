//
//  UINavigationController+GestureBack.h
//  GradientNavigationBar
//
//  Created by Yang on 2017/7/20.
//  Copyright © 2017年 洪海 杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (GestureBack)
// 判断是否是手势侧滑返回
@property (assign, nonatomic) BOOL isGestureBack;

@end



@interface UIViewController (alpha)
// 记录当前控制器导航栏的alpha值
@property (assign, nonatomic) CGFloat navAlpha;

@property (assign, nonatomic) BOOL navTranslucent;

@end
