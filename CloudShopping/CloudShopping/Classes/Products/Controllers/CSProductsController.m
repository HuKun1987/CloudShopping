//
//  CSProductsViewController.m
//  CloudShopping
//
//  Created by 胡坤 on 2017/4/2.
//  Copyright © 2017年 hukun. All rights reserved.
//

#import "CSProductsController.h"
#import "CSPCatergoryListView.h"
#import "CSPDetailListView.h"
#import "CSPToolBarView.h"
#import "CSPProductType.h"
@interface CSProductsController ()<CSPCatergoryListViewDelegate>
@property(nonatomic,strong)CSPCatergoryListView*leftListView;
@property(nonatomic,strong)CSPDetailListView *rightDetailView;
@property(nonatomic,assign)BOOL isDetailStyle;
@property(nonatomic,strong)CSPToolBarView   *toolBar;
@property(nonatomic,strong)NSArray   *productTypeList;
@end

@implementation CSProductsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUPNavBarItems];
    [self setUpUI];
}

- (void)setUPNavBarItems{

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"切换样式" style:UIBarButtonItemStylePlain target:self action:@selector(changeListAndDetailViewStyle)];
}

 CGFloat ToolBarHeight = 44;
 CGFloat ListViewDefaultWidth = 60;
 CGFloat subViewsDefaultOffset = 64;
- (void)setUpUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.leftListView = [[CSPCatergoryListView alloc]init];
    self.leftListView.productTypeList = self.productTypeList;
    self.leftListView.delegate = self;
    [self.view addSubview:self.leftListView];
    
    self.rightDetailView = [CSPDetailListView new];
    [self.view addSubview:self.rightDetailView];
    
    self.toolBar = [CSPToolBarView new];
    [self.view addSubview:self.toolBar];
    [self.leftListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(subViewsDefaultOffset);
        make.left.bottom.equalTo(self.view);
        make.width.mas_equalTo(ListViewDefaultWidth);
    }];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.view).mas_offset(subViewsDefaultOffset);
        make.left.equalTo(self.leftListView.mas_right);
        make.height.mas_equalTo(ToolBarHeight);
    }];
    
    [self.rightDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolBar.mas_bottom);
        make.left.equalTo(self.leftListView.mas_right);
        make.right.bottom.equalTo(self.view);
    }];
}

- (void)changeListAndDetailViewStyle{
    self.isDetailStyle = !self.isDetailStyle;
  
    if (self.isDetailStyle) {
        [self.leftListView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(44);
        }];
       
    }else{
        [self.leftListView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(60);
        }];
    }
   [self.rightDetailView layoutIfNeeded];
   [self.leftListView layoutIfNeeded];
   self.rightDetailView.isDetailStyle = self.isDetailStyle;
   self.leftListView.isDetailStyle = self.isDetailStyle;
}
//懒加载
- (NSArray *)productTypeList{
    if (!_productTypeList) {
        _productTypeList = [CSPProductType productTypeWithContentOfLocalPlistName:@"CSPcatagoryList"];
    }
    return _productTypeList;
}
#pragma mark --CSPCatergoryListViewDelegate
//选中对应的类别后的回调
- (void)pclistViewdidSelectProfuctType:(CSPProductType *)productType{

    DBLog(@"%@",productType.product_iconName);
}
@end
