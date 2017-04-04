//
//  CSPCsingleCell.m
//  CloudShopping
//
//  Created by 胡坤 on 2017/4/3.
//  Copyright © 2017年 hukun. All rights reserved.
//

#import "CSPCsingleCell.h"
#import "CSPProductType.h"

@interface CSPCsingleCell ()
@end

@implementation CSPCsingleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUPUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
  
}

-(void)setUPUI{
    
    self.backgroundColor = [UIColor grayColor];
    UIView *bg = [[UIView alloc]initWithFrame:self.bounds];
    bg.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = bg;
    self.typeNameLable = [UILabel new];
    self.typeNameLable.font = [UIFont systemFontOfSize:11.5];
    [self.typeNameLable setHighlightedTextColor:[UIColor orangeColor]];
    self.typeNameLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.typeNameLable];
    [self.typeNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


- (void)setProductType:(CSPProductType *)productType{
    _productType = productType;
    self.typeNameLable.text = productType.product_name;

}
@end
