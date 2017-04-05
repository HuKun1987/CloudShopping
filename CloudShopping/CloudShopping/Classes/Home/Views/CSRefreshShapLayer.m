//
//  CSRefreshShapLayer.m
//  CloudShopping
//
//  Created by 胡坤 on 2017/4/4.
//  Copyright © 2017年 hukun. All rights reserved.
//

#import "CSRefreshShapLayer.h"
#import "CSShapeHeaderRefresh.h"
//CGFloat RFShapeLayerHeight = 50;

@interface CSRefreshShapLayer ()
@property(nonatomic,strong)UIImageView *animationImgView;
@end

@implementation CSRefreshShapLayer
- (instancetype)init{
    if (self = [super init]) {
        [self setUPSubLayer];
    }
    return self;
}

- (void)setUPSubLayer{
    [self addSublayer:self.animationImgView.layer];
    self.fillColor = [UIColor whiteColor].CGColor;
}

//状态为默认状态时
- (void)setAnimationImgViewWhenStateNormal{
    //动画停止更改图片
    [self.animationImgView stopAnimating];
     self.animationImgView.image = [UIImage imageNamed:@"home_loading_0"];
}
//下拉状态时;
- (void)setAnimationImgViewWhenStatePulling{
  self.animationImgView.image = [UIImage imageNamed:@"home_loading_1"];
}
//状态是刷新状态时
- (void)setAnimationImgViewWhenStateRefreshing{
    //  shape橡皮筋效果去除
    self.path = [self creatNewShapePathWithStart:CGPointZero EndPoint:CGPointZero  ControlPoint:CGPointZero ];
    [self.animationImgView startAnimating];
}
//监听frame的改变
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self updateAnimationImgViewPosition:CGPointMake(frame.size.width*0.5, frame.size.height)];
}
//监听bounds的改变
- (void)setBounds:(CGRect)bounds{
    [super setBounds:bounds];
    [self updateAnimationImgViewPosition:CGPointMake(bounds.size.width*0.5, bounds.size.height)];
}
//更新位置和锚点
-(void)updateAnimationImgViewPosition:(CGPoint)position {
    self.animationImgView.layer.anchorPoint = CGPointMake(0.5, 1);
    self.animationImgView.layer.position = position;
}
#pragma mark --懒加载图片视图
- (UIImageView *)animationImgView
{
    if (!_animationImgView) {
        _animationImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_loading_0"]];
        _animationImgView.contentMode = UIViewContentModeScaleToFill;
        _animationImgView.animationImages = [self getAnimationImgs];
        _animationImgView.animationDuration = 0.5;
        _animationImgView.animationRepeatCount = MAXFLOAT;
        [_animationImgView sizeToFit];
    }
    return _animationImgView;
}
//获取动画的图片数组
- (NSArray *)getAnimationImgs{
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:5];
    for (NSInteger i = 2; i<7; i++){
        [temp addObject: [UIImage imageNamed:[NSString stringWithFormat:@"home_loading_%zd",i]]];
    }
    return temp.copy;
}

#pragma mark -- 更新shape形状和图片的位置
- (void)updateShapeLayerWhenScrollView:(UIScrollView *)scrollView ChangeContentOffset:(CGFloat) offsetY {
    CGFloat topPoint = 0;
    topPoint +=offsetY *0.5;
    //设置新的控制点
    CGPoint newControlPoint = CGPointZero;
    if (-offsetY) {
        
         newControlPoint =  CGPointMake(scrollView.bounds.size.width * 0.5, -offsetY+50);
        //创建一个新的路径
        CGPoint startPoint = CGPointMake(0, self.bounds.size.height);
        CGPoint endPoint = CGPointMake(scrollView.bounds.size.width, self.bounds.size.height);
        self.path = [self creatNewShapePathWithStart:startPoint EndPoint:endPoint ControlPoint:newControlPoint];
        //根据滚动视图的偏移量修改图片的位置
        [self updateAnimationImgViewPosition:CGPointMake(scrollView.bounds.size.width *0.5, newControlPoint.y+topPoint) ];
        
    }else{
        
      self.path = [self creatNewShapePathWithStart:CGPointZero EndPoint:CGPointZero ControlPoint:newControlPoint];
      [self updateAnimationImgViewPosition:CGPointMake(scrollView.bounds.size.width *0.5, self.bounds.size.height) ];
    }
}
#pragma mark --新的shape路径
- (CGPathRef)creatNewShapePathWithStart:(CGPoint)startPoint EndPoint:(CGPoint)endPoint ControlPoint:(CGPoint) newControlPoint{
    //创建一个新的路径
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:endPoint controlPoint:newControlPoint];
    return path.CGPath;
}
#pragma mark --结束刷新状态
- (void)endRefreshing{
    //  shape橡皮筋效果清楚
    self.path = [self creatNewShapePathWithStart:CGPointZero EndPoint:CGPointZero  ControlPoint:CGPointZero ];
}

- (void)setType:(RefreshState)type{
    _type = type;
    if (type == Normal) {
        [self setAnimationImgViewWhenStateNormal];
    }else if (type == Pulling){
        [self setAnimationImgViewWhenStatePulling];
    }else if (type == Refreshing){
        [self setAnimationImgViewWhenStateRefreshing];
    }
}
@end
