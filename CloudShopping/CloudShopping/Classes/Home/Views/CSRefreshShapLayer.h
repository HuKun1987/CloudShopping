//
//  CSRefreshShapLayer.h
//  CloudShopping
//
//  Created by 胡坤 on 2017/4/4.
//  Copyright © 2017年 hukun. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

//  当前刷新控件的刷新状态
typedef enum : NSUInteger {
    Normal,    // 下拉状态
    Pulling,   //松手就刷新
    Refreshing //正在刷新（开始动画）
} RefreshState;
@interface CSRefreshShapLayer : CAShapeLayer
@property(nonatomic, assign) RefreshState type;
- (void)updateShapeLayerWhenScrollView:(UIScrollView *)scrollView ChangeContentOffset:(CGFloat) offsetY;
- (void)setAnimationImgViewWhenStateNormal;
- (void)setAnimationImgViewWhenStateRefreshing;
- (void)setAnimationImgViewWhenStatePulling;
- (void)endRefreshing;
@end
