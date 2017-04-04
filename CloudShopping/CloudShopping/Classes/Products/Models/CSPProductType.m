//
//  CSPProductType.m
//  CloudShopping
//
//  Created by 胡坤 on 2017/4/3.
//  Copyright © 2017年 hukun. All rights reserved.
//

#import "CSPProductType.h"

@implementation CSPProductType

-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
        
    }
    return self;
}

+(instancetype )productTypeWithDic:(NSDictionary *)dic{
    return [[CSPProductType alloc]initWithDic:dic];
}
+(NSArray *)productTypeWithContentOfLocalPlistName:(NSString *)plistName{
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:10];
    NSString *path = [[NSBundle mainBundle]pathForResource:plistName ofType:@"plist"];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *dic  in dataArr)
    {
        [temp addObject:[CSPProductType productTypeWithDic:dic]];
    }
    return temp.copy;
}
@end
