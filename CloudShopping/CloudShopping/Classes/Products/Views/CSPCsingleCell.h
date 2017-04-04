//
//  CSPCsingleCell.h
//  CloudShopping
//
//  Created by 胡坤 on 2017/4/3.
//  Copyright © 2017年 hukun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSPProductType;
@interface CSPCsingleCell : UITableViewCell
@property(nonatomic,strong)CSPProductType *   productType;
@property(nonatomic,strong)UILabel *typeNameLable;
-(void)setUPUI;
@end
