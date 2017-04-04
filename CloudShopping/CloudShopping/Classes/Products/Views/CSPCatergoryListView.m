//
//  CSPCatergoryListView.m
//  CloudShopping
//
//  Created by 胡坤 on 2017/4/2.
//  Copyright © 2017年 hukun. All rights reserved.
//

#import "CSPCatergoryListView.h"
#import "CSPCsingleCell.h"
#import "CSPCIconViewCell.h"
#import "CSPProductType.h"
static NSString *defalutCellID = @"defalutCellID";
static NSString *detailCellID = @"detailCellID";
@interface CSPCatergoryListView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView  * listTableView;
@property(nonatomic,strong)NSIndexPath  *selectedIndexPath;
@end

@implementation CSPCatergoryListView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUPUI];
    
    }
    return self;
}

- (void)setUPUI{
    self.listTableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    self.listTableView.showsVerticalScrollIndicator = NO;
    self.listTableView.backgroundColor = [UIColor lightGrayColor];
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.rowHeight = 44;
    [self addSubview:self.listTableView];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.listTableView registerClass:[CSPCsingleCell class] forCellReuseIdentifier:defalutCellID];
    [self.listTableView registerClass:[CSPCIconViewCell class] forCellReuseIdentifier:detailCellID];
}
//监听更改显示的样式
- (void)setIsDetailStyle:(BOOL)isDetailStyle{
    _isDetailStyle = isDetailStyle;
    if (isDetailStyle) {
        self.listTableView.rowHeight = 70;
    }else{
       self.listTableView.rowHeight = 44;
    }
    [self.listTableView reloadData];
        [self.listTableView selectRowAtIndexPath:self.selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
}

- (void)setProductTypeList:(NSArray *)productTypeList{
    _productTypeList = productTypeList;
    [self.listTableView selectRowAtIndexPath:self.selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];

}
#pragma make -- datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.productTypeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * ID = self.isDetailStyle?detailCellID:defalutCellID;
    CSPCsingleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.productType = self.productTypeList[indexPath.row];
    return cell;
}
#pragma make -- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedIndexPath = indexPath;
    if ([self.delegate respondsToSelector:@selector(pclistViewdidSelectProfuctType:)])
    {
        [self.delegate pclistViewdidSelectProfuctType:self.productTypeList[indexPath.row]];
    }
}


-(NSIndexPath *)selectedIndexPath{
    if (!_selectedIndexPath) {
        _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return _selectedIndexPath;

}
@end
