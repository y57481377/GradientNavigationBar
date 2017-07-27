//
//  MeViewController.m
//  GradientNavigationBar
//
//  Created by Yang on 2017/7/24.
//  Copyright © 2017年 洪海 杨. All rights reserved.
//

#import "MeViewController.h"
#import "ViewController.h"
#import "UINavigationController+GestureBack.h"

@interface MeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@end

const CGFloat alphaOffset = 200; //渐变偏移量---划过offset高度后导航栏开始渐变
const CGFloat alphaLimit = 100; // 渐变比例---每滑过1高度导航栏渐变 1/limit
@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.title = @"个人中心";
//    self.navigationController.navigationBar.translucent = YES;
//    self.navTranslucent = YES;
    self.navAlpha = 0.0;
    
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor yellowColor];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
    header.backgroundColor = [UIColor darkGrayColor];
    _tableView.tableHeaderView = header;
    [self.view addSubview:_tableView];
    
    self.view.backgroundColor = [UIColor grayColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *渐变代码
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGFloat offsetY = scrollView.contentOffset.y;
        [self setNavigationBarColorWithOffsetY:offsetY];
    }
}

// 界面滑动时导航栏随偏移量 实时变化
- (void)setNavigationBarColorWithOffsetY:(CGFloat)offsetY {
    
    CGFloat s = offsetY - alphaOffset;
    if (s > 0) {
        self.navAlpha = s/alphaLimit > 1 ? 1 : s/alphaLimit;
    }else {
        self.navAlpha = 0;
    }
}



#pragma mark --- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellaaa";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        UIView *view = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 50, 30)];
        view.backgroundColor = [UIColor blackColor];
        [cell addSubview:view];
        
        UIView *view1 = [[UILabel alloc] initWithFrame:CGRectMake(150, 50, 50, 30)];
        view1.backgroundColor = [UIColor redColor];
        [cell addSubview:view1];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(200, 8, 90, 40);
        btn.backgroundColor = [UIColor grayColor];
        [btn setTitle:@"popTovc" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
        
        UIButton *root = [UIButton buttonWithType:UIButtonTypeCustom];
        root.frame = CGRectMake(200, 56, 90, 40);
        root.backgroundColor = [UIColor grayColor];
        [root setTitle:@"popToRoot" forState:UIControlStateNormal];
        [root addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:root];
    }
    cell.textLabel.text = @(indexPath.row).stringValue;
    
    return cell;
}

- (void)back:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@"popToRoot"]) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else {
        
        NSInteger count = self.navigationController.viewControllers.count;
        if (count >= 3) {
            UIViewController *vc = self.navigationController.viewControllers[count - 3];
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

#pragma mark --- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewController *vc = [[ViewController alloc] init];
    
    vc.title = @(indexPath.row).stringValue;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
