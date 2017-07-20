//
//  NSObject+Runtime.h
//  GradientNavigationBar
//
//  Created by YANG on 2017/7/19.
//  Copyright © 2017年 洪海 杨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Runtime)
- (NSArray *)getAllMethods;

- (NSArray *)getAllProperties;

- (NSArray *)getAllIvars;
@end
