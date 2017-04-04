//
//  CSRefreshShapLayer.h
//  CloudShopping
//
//  Created by 胡坤 on 2017/4/4.
//  Copyright © 2017年 hukun. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CSRefreshShapLayer : CAShapeLayer
@property(nonatomic,copy)void(^startRefresh)();
- (void)setCurrentScrollView:(UIScrollView *)currentScrollView;
- (void)endRefreshing;
@end
