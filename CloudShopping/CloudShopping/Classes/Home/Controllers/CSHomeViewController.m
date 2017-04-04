//
//  CSHomeViewController.m
//  CloudShopping
//
//  Created by 胡坤 on 2017/4/2.
//  Copyright © 2017年 hukun. All rights reserved.
//

#import "CSHomeViewController.h"
#import "CSRefreshShapLayer.h"
#import "CSHomeTabHeader.h"
#import "CSShapeHeaderRefresh.h"
@interface CSHomeViewController ()<UITableViewDelegate>
@property(nonatomic,strong)UITableView   *homeTab;
@property(nonatomic,strong)CSRefreshShapLayer  *shapeLayer;
@property(nonatomic)CGPoint controlPoint;
@end

@implementation CSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUPNav];
    [self setUPHomeTab];
}

- (void)setUPNav{
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"homepage_title"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_home_background_image"] forBarPosition: UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)setUPHomeTab{
    self.homeTab = [[UITableView alloc]init];
    self.homeTab.delegate = self;
    [self.view addSubview:self.homeTab];
    [self.homeTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self setHomeTabHeader];
}

- (void)setHomeTabHeader{
    CSHomeTabHeader *headerView = [[CSHomeTabHeader alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250)];
    headerView.backgroundColor = [UIColor redColor];
    self.homeTab.tableHeaderView = headerView;
    CSShapeHeaderRefresh *refreshControl = [[CSShapeHeaderRefresh alloc]init];
    [refreshControl add2TabHeaderView:self.homeTab.tableHeaderView];
}


@end
