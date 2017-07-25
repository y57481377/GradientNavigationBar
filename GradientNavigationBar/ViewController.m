//
//  ViewController.m
//  导航栏透明渐变
//
//  Created by Yang on 2017/7/19.
//  Copyright © 2017年 YHH. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationController+GestureBack.h"
#import "MeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /** 
     如果是不透明到与透明之间的切换需要给控制器设置 extendedLayoutIncludesOpaqueBars = YES
     extendedLayoutIncludesOpaqueBars属性让self.view的(0，0)从屏幕左上角起
     */
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"背景图导航栏";
    self.navigationController.navigationBar.translucent = NO;
    self.navTranslucent = NO;
    self.navAlpha = 1;
//    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    MeViewController *vc = [[MeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
