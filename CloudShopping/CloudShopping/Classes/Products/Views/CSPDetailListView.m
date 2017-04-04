//
//  CSPDetailListView.m
//  CloudShopping
//
//  Created by 胡坤 on 2017/4/2.
//  Copyright © 2017年 hukun. All rights reserved.
//

#import "CSPDetailListView.h"
#import "CSPDdetailLayout.h"
#import "CSPDlistLayout.h"
#import "CSPDlistCollectionCell.h"
#import "CSPDdetailCollectionCell.h"
#import "CSPDdetailCollectionCell.h"
static NSString *detailCollectionCellListStyleID = @"detailCollectionCellListStyleID";
static NSString *detailCollectionCelldetailStyleID = @"detailCollectionCelldetailStyleID";
@interface CSPDetailListView ()<UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView   *detailCollection;

@end

@implementation CSPDetailListView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUPUI];
    }
    
    return self;
}

- (void)setUPUI{
    [self setUPDetailCollection];
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];

 
}

- (void)setUPDetailCollection{
    self.detailCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 1.5, 1.5) collectionViewLayout:[[CSPDlistLayout alloc]init]];
    self.detailCollection.backgroundColor = [UIColor lightGrayColor];
    self.detailCollection.dataSource = self;
    [self addSubview:self.detailCollection];
    [self.detailCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.detailCollection registerNib:[UINib nibWithNibName:@"CSPDlistCollectionCell" bundle:nil] forCellWithReuseIdentifier:detailCollectionCellListStyleID];
    
    [self.detailCollection registerNib:[UINib nibWithNibName:@"CSPDdetailCollectionCell" bundle:nil] forCellWithReuseIdentifier:detailCollectionCelldetailStyleID];
    
}

- (void)setIsDetailStyle:(BOOL)isDetailStyle{
    _isDetailStyle = isDetailStyle;

    if (isDetailStyle) {
        self.detailCollection.collectionViewLayout = [CSPDdetailLayout new];
    }else{
    self.detailCollection.collectionViewLayout = [CSPDlistLayout new];
    }
  
    [self.detailCollection reloadData];
}

#pragma mark -- dataSourece

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = self.isDetailStyle?detailCollectionCelldetailStyleID:detailCollectionCellListStyleID;
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}
@end
