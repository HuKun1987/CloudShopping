//
//  CSPProductType.h
//  CloudShopping
//
//  Created by 胡坤 on 2017/4/3.
//  Copyright © 2017年 hukun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSPProductType : NSObject
@property(nonatomic,copy)NSString   *product_name;
@property(nonatomic,copy)NSString   *product_iconName;
@property(nonatomic,strong)NSNumber   *product_id;
+(NSArray *)productTypeWithContentOfLocalPlistName:(NSString *)plistName;
@end
