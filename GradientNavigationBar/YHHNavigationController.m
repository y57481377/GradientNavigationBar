//
//  YHHNavigationController.m
//  GradientNavigationBar
//
//  Created by YANG on 2017/7/19.
//  Copyright © 2017年 洪海 杨. All rights reserved.
//

#import "YHHNavigationController.h"
#import "NSObject+Runtime.h"
#import <objc/runtime.h>

@interface YHHNavigationController ()

@end

@implementation YHHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SEL sysSEl = NSSelectorFromString(@"_updateInteractiveTransition");
    SEL mySEL = NSSelectorFromString(@"yhh_updateInteractiveTransition");
    Method sysMethod = class_getInstanceMethod([self class], sysSEl);
    Method myMethod = class_getInstanceMethod([self class], mySEL);
    method_exchangeImplementations(sysMethod, myMethod);
    
    NSArray *methodArr = [self.superclass getAllMethods];
    
    NSLog(@"%@",methodArr);
    
    NSArray *properties = [self.superclass getAllProperties];
    NSLog(@"%@", properties);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
