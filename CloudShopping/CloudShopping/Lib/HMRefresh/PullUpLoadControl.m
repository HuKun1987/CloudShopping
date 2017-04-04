//
//  PullUpLoadControl.m
//  HowToDo
//
//  Created by 胡坤 on 2017/1/9.
//  Copyright © 2017年 KY. All rights reserved.
//

#import "PullUpLoadControl.h"
//  当前刷新控件的高度
CGFloat RefreshControlHeight = 50;
//  定义底部刷新枚举类型
typedef enum : NSUInteger {
    Normal,
    Pulling,
    Refreshing,
} RefreshType;
@interface PullUpLoadControl ()
//  当前属性状态
@property(nonatomic, assign) RefreshType refreshType;
@property(nonatomic, assign) RefreshType lastRefreshType;
//  当前滚动的控件
@property(nonatomic, strong) UIScrollView *currentScrollView;

@end
@implementation PullUpLoadControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //  初始化刷新状态
        self.refreshType = Normal;
        self.lastRefreshType = Normal;
        [self setUPUI];
    }
    return self;
}
-(void)setUPUI
{
    //  风火轮
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.tag = 101;
    //  消息label
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.tag = 102;
    msgLabel.text = @"上拉加载";
    msgLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:indicatorView];
    [self addSubview:msgLabel];
    msgLabel.textColor = [UIColor lightGrayColor];
    //  设置约束
    indicatorView.translatesAutoresizingMaskIntoConstraints = false;
    msgLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:indicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:-40]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:indicatorView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:msgLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:indicatorView attribute:NSLayoutAttributeRight multiplier:1 constant:5]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:msgLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:indicatorView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

}


- (void)setRefreshType:(RefreshType)refreshType
{
    //  设置数值
    _refreshType = refreshType;
    //  获取风火轮
    UIActivityIndicatorView *indicatorView = [self viewWithTag:101];
    UILabel *msgLabel = [self viewWithTag:102];
    
    switch (refreshType)
    {
        case Normal:
            msgLabel.text = @"上拉加载";
            //  停止风火轮
            [indicatorView stopAnimating];
            if (self.lastRefreshType == Refreshing)
            {
                //  设置原始位置
                self.currentScrollView.contentInset = UIEdgeInsetsZero;
                //  设置底部刷新控件的位置
                self.frame = CGRectMake(0,self.currentScrollView.contentSize.height?:self.currentScrollView.bounds.size.height, self.currentScrollView.frame.size.width, RefreshControlHeight);
            }
            break;
        case Pulling:
            msgLabel.text = @"松手就刷新";
            break;
        case Refreshing:
            //  设置文字
            msgLabel.text = @"正在刷新";
            //  开启风火轮
            [indicatorView startAnimating];
            //  设置停留
            [UIView animateWithDuration:0.25 animations:^
             {
                 self.currentScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, -self.currentScrollView.contentSize.height);
             }completion:^(BOOL finished)
             {
                 //  发送刷新事件
                 [self sendActionsForControlEvents:UIControlEventValueChanged];
             }];
            
            
            
            break;
    }
}
- (void)endRefresh
{
    self.refreshType = Normal;
}

#pragma mark --开始刷新


// 添加到父控件的时候获取父控件，监听器滚动
- (void)willMoveToSuperview:(UIView *)newSuperview {
    //  判断父控件是否可以滚动
    if ([newSuperview isKindOfClass: [UIScrollView class]]) {
        
        //  记录当前滚动的父视图
        self.currentScrollView = (UIScrollView *)newSuperview;
        
        //  获取父控件的宽度，设置当前刷新控件的宽度
        CGRect rect = CGRectMake(0, self.currentScrollView.bounds.size.height+ RefreshControlHeight, self.currentScrollView.frame.size.width, RefreshControlHeight);
        
        self.frame = rect;
        
        
        //  监听父控件的滚动
        [self.currentScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        [self.currentScrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    
}
//  结束刷新
- (void)endPullUpFreshing
{
    self.refreshType= Normal;
    
}

- (void)dealloc
{
    //  移除kvo
    [self.currentScrollView removeObserver:self forKeyPath:@"contentOffset"];
    //  移除kvo
    [self.currentScrollView removeObserver:self forKeyPath:@"contentSize"];
}
#pragma mark -- kvo监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString: @"contentOffset"])
    {
        //  设置临界点
        CGFloat maxY = self.currentScrollView.contentSize.height + self.frame.size.height;
        //  垂直偏移量
        CGFloat conentOffSetY = self.currentScrollView.contentOffset.y;
        
        
        //  滚动偏移量
        CGFloat scrollOffSetY = conentOffSetY + self.currentScrollView.frame.size.height;
        
        //  判断是否是在拖动
        if ([self.currentScrollView isDragging])
        {
            if (scrollOffSetY > maxY && self.refreshType == Normal)
            {
                //  记录上次刷新状态
                self.lastRefreshType = Pulling;
                self.refreshType = Pulling;
                NSLog(@"pulling");
            } else if (scrollOffSetY <= maxY && self.refreshType == Pulling)
            {
                //  记录上次刷新状态
                self.lastRefreshType = normal;
                self.refreshType = Normal;
                NSLog(@"normal");
            }
        }
        else
        {
            if (self.refreshType == Pulling)
            {
                //  记录上次刷新状态
                self.lastRefreshType = Refreshing;
                self.refreshType = Refreshing;
                NSLog(@"Refreshing");
                
            }
        }
    }
    else if ([keyPath isEqualToString:@"contentSize"])
    {
        
        //  如果没有加载回来数据tableView的contentSize的大小是0,0,设置frame的大小就可以了
        if (self.currentScrollView.contentSize.height < self.currentScrollView.frame.size.height)
        {
            //  默认位置
            self.frame = CGRectMake(0, self.currentScrollView.frame.size.height, self.currentScrollView.frame.size.width, 50);
        } else
        {
            //  默认位置
            self.frame = CGRectMake(0, self.currentScrollView.contentSize.height , self.currentScrollView.frame.size.width, 50);
        }
    }
}


@end
