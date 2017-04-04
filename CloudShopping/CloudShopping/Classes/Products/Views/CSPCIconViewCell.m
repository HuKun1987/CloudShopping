//
//  CSPCIconViewCell.m
//  CloudShopping
//
//  Created by 胡坤 on 2017/4/3.
//  Copyright © 2017年 hukun. All rights reserved.
//

#import "CSPCIconViewCell.h"
#import "CSPProductType.h"
@interface CSPCIconViewCell ()
@property(nonatomic,strong)UIImageView *iconView;
@end
@implementation CSPCIconViewCell

- (void)setUPUI{
    [super setUPUI];
    self.typeNameLable.numberOfLines = 0;
    self.iconView = [[UIImageView alloc]init];
    [self addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(8);
        make.left.equalTo(self).mas_offset(10);
        make.right.equalTo(self).mas_offset(-10);
        make.height.equalTo(self.iconView.mas_width);
    }];
    
    [self.typeNameLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(10);
        make.bottom.right.equalTo(self).mas_offset(-10);
        make.top.equalTo(self.iconView.mas_bottom);
    }];
}

- (void)setProductType:(CSPProductType *)productType{
    [super setProductType:productType];
    
    self.iconView.image = [UIImage imageNamed:productType.product_iconName];
    self.iconView.highlightedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",productType.product_iconName]];
}
@end
