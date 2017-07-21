//
//  ViewController.m
//  导航栏透明渐变
//
//  Created by Yang on 2017/7/19.
//  Copyright © 2017年 YHH. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationController+GestureBack.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;

@end

const CGFloat limit = 100; // 渐变范围
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"导航栏渐变";
    self.navigationController.navigationBar.translucent = YES;
    self.navAlpha = 0.0;
    
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor yellowColor];
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
    CGFloat alpha = offsetY / limit;
    self.navAlpha = alpha > 1 ? 1 : alpha;
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
        
        UIView *view1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 50, 30)];
        view1.backgroundColor = [UIColor redColor];
        [cell addSubview:view1];
    }
    cell.textLabel.text = @(indexPath.row).stringValue;
    
    return cell;
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
