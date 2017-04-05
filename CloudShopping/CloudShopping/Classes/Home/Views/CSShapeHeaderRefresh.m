//
//  CSShapeHeaderRefresh.m
//  CloudShopping
//
//  Created by 胡坤 on 2017/4/4.
//  Copyright © 2017年 hukun. All rights reserved.
//

#import "CSShapeHeaderRefresh.h"
#import "CSRefreshShapLayer.h"
//CGFloat RFShapeLayerHeight = 50;
//  当前刷新控件的刷新状态
//typedef enum : NSUInteger {
//    Normal,    // 下拉状态
//    Pulling,   //松手就刷新
//    Refreshing //正在刷新（开始动画）
//} RefreshState;

@interface CSShapeHeaderRefresh ()
@property(nonatomic,strong)CSRefreshShapLayer  *shapeLayer;
@property(nonatomic,strong)UIScrollView *superScrollView;
@property(nonatomic, assign) RefreshState type;
@property(nonatomic, assign) RefreshState lastType;
@end
@implementation CSShapeHeaderRefresh
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUPUI];
    }
    return self;
}

- (void)setUPUI{
    self.backgroundColor = [UIColor yellowColor];
    //  初始化刷新状态
    self.type = Normal;
    self.lastType = Normal;

}

- (void)add2TabHeaderView:(UIView *)tableHeaderView{
    CGRect frame = tableHeaderView.frame;
    self.frame = CGRectMake(0, -50, frame.size.width, 50);
    self.shapeLayer = [CSRefreshShapLayer layer];
    self.shapeLayer.frame = self.bounds;
    [self.layer addSublayer:self.shapeLayer];
    [tableHeaderView addSubview:self];
    NSAssert1([tableHeaderView.superview isKindOfClass:[UIScrollView class]], @"%@不是一个滚动视图",tableHeaderView.superview);
    self.superScrollView = (UIScrollView *)tableHeaderView.superview;
        //  监听父控件的滚动
    [self.superScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark --监听拖拽状态的改变
- (void)setType:(RefreshState)type{
    _type = type;
    //更改shape的状态
    self.shapeLayer.type = type;
    //  根据不同的状态设置不同的视图
    switch (type) {
        case Normal: {
            [self refreshStateNormalConfiguration];
            break;
        }
        case Pulling: {
            [self refreshStatePullingConfiguration];
            break;
        }
        case Refreshing: {
            [self refreshStateRefreshingConfiguration];
            break;
        }
    }
}
//正常状态
- (void)refreshStateNormalConfiguration{
   
}
//下拉状态
- (void)refreshStatePullingConfiguration{

}
//刷新状态
- (void)refreshStateRefreshingConfiguration{
    self.superScrollView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endRefreshing];
        self.superScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    });
}
//结束刷新
-  (void)endRefreshing{
    [self.shapeLayer endRefreshing];
    self.type = Normal;
    self.lastType = Normal;
}
//  监听kvo方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //  获取当前滚动的偏移量
    CGFloat contentOffSetY = self.superScrollView.contentOffset.y;
    //  刷新的临界点
    CGFloat maxY = -(self.superScrollView.contentInset.top + 50);
    //  判断是否是拖动
    if (self.superScrollView.isDragging){
        //更新shape的形状和图片的位置
        [self.shapeLayer updateShapeLayerWhenScrollView:self.superScrollView ChangeContentOffset:contentOffSetY];
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
    {   //松手就让shape的形状回复到初始状态
        [self.shapeLayer updateShapeLayerWhenScrollView:self.superScrollView ChangeContentOffset:0];
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

-(void)dealloc{
    [self.superScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
