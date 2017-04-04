//
//  CSRefreshShapLayer.m
//  CloudShopping
//
//  Created by 胡坤 on 2017/4/4.
//  Copyright © 2017年 hukun. All rights reserved.
//

#import "CSRefreshShapLayer.h"

CGFloat RFShapeLayerHeight = 50;
//  当前刷新控件的刷新状态
typedef enum : NSUInteger {
    Normal,    // 下拉状态
    Pulling,   //松手就刷新
    Refreshing //正在刷新（开始动画）
} RefreshState;

@interface CSRefreshShapLayer ()
//  当前滚动的控件
@property(nonatomic, strong) UIScrollView *currentScrollView;
@property(nonatomic,strong)UIImageView *animationImgView;
@property(nonatomic, assign) RefreshState type;
@property(nonatomic, assign) RefreshState lastType;
@property(nonatomic)CGPoint controlPoint;
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
    //  初始化刷新状态
    self.type = Normal;
    self.lastType = Normal;
    self.controlPoint = CGPointMake(self.bounds.size.width *0.5, self.bounds.size.height);
    self.fillColor = [UIColor whiteColor].CGColor;
}
#pragma mark --监听拖拽状态的改变
- (void)setType:(RefreshState)type{
    _type = type;
    //  根据不同的状态设置不同的视图
    switch (type) {
        case Normal: {
            [self setAnimationImgViewWhenStateNormal];
            break;
        }
        case Pulling: {
            self.animationImgView.image = [UIImage imageNamed:@"home_loading_1"];
            break;
        }
        case Refreshing: {
            [self setAnimationImgViewWhenStateRefreshing];
            break;
        }
    }
}
//状态为下拉状态时
- (void)setAnimationImgViewWhenStateNormal{
    //动画停止更改图片
    [self.animationImgView stopAnimating];
    self.animationImgView.image = [UIImage imageNamed:@"home_loading_0"];
}
//状态是刷新状态时
- (void)setAnimationImgViewWhenStateRefreshing{
    [self backToNormalState];
    [self.animationImgView startAnimating];
    self.currentScrollView.contentInset = UIEdgeInsetsMake(RFShapeLayerHeight, 0, 0, 0);
  
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endRefreshing];
        self.currentScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    });
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
//获取到被添加到哪个滚动视图上，并使用KVO监听偏移量
- (void)setCurrentScrollView:(UIScrollView *)currentScrollView{
    _currentScrollView  = currentScrollView;
    //  监听父控件的滚动
    [self.currentScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}
//  监听kvo方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //  获取当前滚动的偏移量
    CGFloat contentOffSetY = self.currentScrollView.contentOffset.y;
    //  刷新的临界点
    CGFloat maxY = -(self.currentScrollView.contentInset.top + RFShapeLayerHeight);
    //  判断是否是拖动
    if (self.currentScrollView.isDragging)
    {
        [self updateShapeLayerPathWithContentOffsetY:contentOffSetY ];
        //  拖动，拖动情况下只有两种状态，normal，pulling
        if (contentOffSetY < maxY && self.type == Normal)
        {
            //  记录上次刷新状态
            self.lastType = Pulling;
            //  进入pulling状态
            self.type = Pulling;
        } else if (contentOffSetY >= maxY && self.type == Pulling)
        {
            //  记录上次刷新状态
            self.lastType = Normal;
            //  进入normal状态
            self.type = Normal;
        }
    } else
    {
        [self updateShapeLayerPathWithContentOffsetY:0 ];
        //  松手，只有上一次的刷新状态是pulling状态，才能进入refreshing状态
        if (self.type == Pulling)
        {
            //  记录上次刷新状态
            self.lastType = Refreshing;
            //  进入正在刷新
            self.type = Refreshing;
        }
    }
}
#pragma mark -- 更新shape形状和图片的位置
- (void)updateShapeLayerPathWithContentOffsetY:(CGFloat)offsetY{
    CGFloat topPoint = 0;
    topPoint +=offsetY *0.5;
    //设置新的控制点
    self.controlPoint = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, -offsetY+50);
    //创建一个新的路径
    CGPoint startPoint = CGPointMake(0, RFShapeLayerHeight);
    CGPoint endPoint = CGPointMake(self.currentScrollView.bounds.size.width, RFShapeLayerHeight);
    self.path = [self creatNewShapePathWithStart:startPoint EndPoint:endPoint];
    //根据滚动视图的偏移量修改图片的位置
    [self updateAnimationImgViewPosition:CGPointMake([UIScreen mainScreen].bounds.size.width *0.5, self.controlPoint.y+topPoint) ];
}
#pragma mark --新的shape路径
- (CGPathRef)creatNewShapePathWithStart:(CGPoint)startPoint EndPoint:(CGPoint)endPoint{
    //创建一个新的路径
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:endPoint controlPoint:self.controlPoint];
    return path.CGPath;
}
#pragma mark --结束刷新状态
- (void)endRefreshing{
    //  记录上次刷新状态
    self.lastType = Normal;
    //  进入正在刷新
    self.type = Normal;
    //  shape橡皮筋效果清楚
    [self backToNormalState];
}
#pragma mark --shape回到初始状态
- (void)backToNormalState{
    self.controlPoint = CGPointMake(0, 0);
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addQuadCurveToPoint:CGPointMake(0, 0) controlPoint:self.controlPoint];
    self.path = path.CGPath;
}

@end
