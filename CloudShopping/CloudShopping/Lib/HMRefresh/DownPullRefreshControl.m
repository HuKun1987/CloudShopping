//
//  RefreshControl.m
//  Refresh
//
//  Created by Apple on 16/12/22.
//  Copyright © 2016年 KY. All rights reserved.
//

#import "DownPullRefreshControl.h"

//  当前刷新控件的高度
CGFloat RefreshHeight = 60;
//  当前刷新控件的刷新状态
typedef enum : NSUInteger {
    //  下拉刷新状态
    Normal,
    //  松手就刷新
    Pulling,
    //  正在刷新
    Refreshing
} RefreshControlType;

@interface DownPullRefreshControl ()
@property(nonatomic, strong) UIImageView *iconImageView;
//  当前滚动的控件
@property(nonatomic, strong) UIScrollView *currentScrollView;
//  当前属性状态
@property(nonatomic, assign) RefreshControlType type;
@property(nonatomic, assign) RefreshControlType lastType;
@end

@implementation DownPullRefreshControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        //  初始化刷新状态
        self.type = Normal;
        self.lastType = Normal;
        //  初始化控件
        [self setupUI];
    }
    return self;
}

//  添加控件设置约束
- (void)setupUI {
    //  添加控件
    [self addSubview:self.iconImageView];
    //  使用手写代码方式布局
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
}

//  重写刷新状态，根据不同状态进入不同的视图
- (void)setType:(RefreshControlType)type {
    //  设置最新状态
    _type = type;
    
    //  根据不同的状态设置不同的视图
    switch (type) {
        case Normal: {
            //  箭头显示, 箭头重置，风火轮停止，文字改成下拉刷新
            [self.iconImageView stopAnimating];
            self.iconImageView.image = [UIImage imageNamed:@"home_loading_0"];
            //  上一次是正在刷新，设置原始的停留位置
            if (self.lastType == Refreshing)
            {
                CGFloat height = [self getCurrentScrollViewContentInsetNormalHeightAfterRefresh];
                [UIView animateWithDuration:0.2 animations:^
                {
                    //  设置停留
                    self.currentScrollView.contentInset = UIEdgeInsetsMake(self.currentScrollView.contentInset.top - RefreshHeight, 0, height, 0);
                }];
            }
            break;
        }
        case Pulling: {
            self.iconImageView.image = [UIImage imageNamed:@"home_loading_1"];
            break;
        }
        case Refreshing: {
            [self startIconViewAnimation];
            //  设置停留
            [UIView animateWithDuration:0.35 animations:^
            {
                self.currentScrollView.contentInset = UIEdgeInsetsMake(RefreshHeight + self.currentScrollView.contentInset.top, 0, 0, 0);
                
            }completion:^(BOOL finished)
            {
                //  发送刷新事件
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }];
            break;
        }
    }
}

- (void)startIconViewAnimation{
    self.iconImageView.animationDuration = 0.25;
    self.iconImageView.animationRepeatCount = MAXFLOAT;
    [self.iconImageView startAnimating];
}

// 添加到父控件的时候获取父控件，监听器滚动
- (void)didMoveToSuperview{
    //  判断父控件是否可以滚动
    if ([self.superview isKindOfClass: [UIScrollView class]])
    {
        [self.superview setNeedsLayout];
        //  记录当前滚动的父视图
        self.currentScrollView = (UIScrollView *)self.superview;
        //  获取父控件的宽度，设置当前刷新控件的宽度
        CGRect rect = CGRectMake(0, -RefreshHeight, [UIScreen mainScreen].bounds.size.width, RefreshHeight);
        self.frame = rect;
        //  监听父控件的滚动
        [self.currentScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}
//  监听kvo方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //  获取当前滚动的偏移量
    CGFloat contentOffSetY = self.currentScrollView.contentOffset.y;
    //  刷新的临界点
    CGFloat maxY = -(self.currentScrollView.contentInset.top + RefreshHeight);
    //  判断是否是拖动
    if (self.currentScrollView.isDragging)
    {
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


//  结束刷新
- (void)endRefreshing
{
    self.type = Normal;
    self.lastType = Normal;
}
//  移除kvo
- (void)dealloc
{
    [self.currentScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (CGFloat)getCurrentScrollViewContentInsetNormalHeightAfterRefresh
{
    UIResponder *next = [self.currentScrollView nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]])
        {
            UIViewController * vc = (UIViewController*)next;
            do
            {
                if ([vc.parentViewController isKindOfClass:[UITabBarController class]])
                {
                    return 49;
                }
                vc = vc.parentViewController;
            }while (vc.parentViewController !=nil);
        }
        next = [next nextResponder];
    } while (next != nil);

    return 0;
}


- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_loading_0"]];
        
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:5];
        for (NSInteger i = 2; i<7; i++)
        {
            [temp addObject: [UIImage imageNamed:[NSString stringWithFormat:@"home_loading_%zd",i]]];
        }
        _iconImageView.animationImages = temp.copy;
        
        [_iconImageView sizeToFit];
    }
    return _iconImageView;
}


@end
