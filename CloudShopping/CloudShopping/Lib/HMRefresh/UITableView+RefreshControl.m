//
//  UITableView+refreshControl.m
//  HowToDo
//
//  Created by 胡坤 on 2017/1/9.
//  Copyright © 2017年 KY. All rights reserved.
#import "UITableView+refreshControl.h"
#import "DownPullRefreshControl.h"
#import "PullUpLoadControl.h"
#import <objc/runtime.h>
@interface UITableView()
/**
 
 */
@property(nonatomic,strong)DownPullRefreshControl* downLoadrefresh;
/**
 
 */
@property(nonatomic,strong)PullUpLoadControl * pullLoadRefresh;
@end
static const char keyTitle;
static const char pullkey;
@implementation UITableView (RefreshControl)


-(void)endRefresh
{

    [self.downLoadrefresh endRefreshing];
}

/** 获取当前View的控制器对象 */
-(UITableView *)getCurrentSuperTabView{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UITableView class]]) {
            return (UITableView *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

-(void)setDownLoadrefresh:(DownPullRefreshControl *)downLoadrefresh
{
    objc_setAssociatedObject(self, &keyTitle, downLoadrefresh, OBJC_ASSOCIATION_RETAIN);

}

-(DownPullRefreshControl *)downLoadrefresh
{
    return objc_getAssociatedObject(self, &keyTitle);
}

-(void)setPullLoadRefresh:(PullUpLoadControl *)pullLoadRefresh
{
    objc_setAssociatedObject(self, &pullkey, pullLoadRefresh, OBJC_ASSOCIATION_RETAIN);
}

-(PullUpLoadControl *)pullLoadRefresh
{
  return objc_getAssociatedObject(self, &pullkey);
}

//设置下拉刷新
- (void)addTableViewRefreshHeaderWhenPullToPerformAction:(nonnull SEL)action
{

        DownPullRefreshControl *downLoadrefresh = [[DownPullRefreshControl alloc]init];
        
        [self addSubview:downLoadrefresh];
        
        self.downLoadrefresh = downLoadrefresh;
        
        UITableView *currentV = [self getCurrentSuperTabView];
        
        [downLoadrefresh addTarget:currentV action:action forControlEvents:UIControlEventValueChanged];

}

//设置上拉下载
- (void)addTableViewRefreshFooterWhenPullToPerformAction:(nonnull SEL)action
{
    if (self)
    {
        PullUpLoadControl *pullupRefresh = [[PullUpLoadControl alloc]init];
        [self addSubview:pullupRefresh];
        
        self.pullLoadRefresh = pullupRefresh;
   
        UITableView *currentV = [self getCurrentSuperTabView];
        
        [pullupRefresh addTarget:currentV action:action forControlEvents:UIControlEventValueChanged];
    }
}

-(void)endPullUPRefresh
{
    [self.pullLoadRefresh endPullUpFreshing];
}

@end
