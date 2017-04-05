//
//  CSHomeTabHeader.m
//  CloudShopping
//
//  Created by 胡坤 on 2017/4/3.
//  Copyright © 2017年 hukun. All rights reserved.
//

#import "CSHomeTabHeader.h"
#import "CSShapeHeaderRefresh.h"
@interface CSHomeTabHeader ()
//底部弧形视图
@property(nonatomic,strong)CAShapeLayer   *bottomLayer;
@end

@implementation CSHomeTabHeader
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
     
       
        [self.layer addSublayer:self.bottomLayer];
    }
    return self;
}

- (void)didMoveToSuperview{
    CSShapeHeaderRefresh *refreshControl = [[CSShapeHeaderRefresh alloc]init];
    [refreshControl add2TabHeaderView:self];
}

- (CAShapeLayer *)bottomLayer{

    if (!_bottomLayer) {
        _bottomLayer = [CAShapeLayer layer];
        _bottomLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _bottomLayer.bounds = CGRectMake(0, 0, self.bounds.size.width, 5);
        
        _bottomLayer.anchorPoint = CGPointMake(0.5, 1);
        _bottomLayer.position = CGPointMake(self.bounds.size.width* 0.5, self.bounds.size.height);
        
        _bottomLayer.fillColor = [UIColor whiteColor].CGColor;
        _bottomLayer.strokeColor = [UIColor whiteColor].CGColor;
    }
    return _bottomLayer;
}

- (void)setBottomLayerPath{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addQuadCurveToPoint:CGPointMake(self.bounds.size.width, 0) controlPoint:CGPointMake(self.bounds.size.width* 0.5, -50)];
    self.bottomLayer.path = path.CGPath;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self setBottomLayerPath];
}
@end
