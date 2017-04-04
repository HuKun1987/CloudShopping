//
//  UITableView+refreshControl.h
//  HowToDo
//
//  Created by 胡坤 on 2017/1/9.
//  Copyright © 2017年 KY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (RefreshControl)

//添加下拉刷新
- (void)addTableViewRefreshHeaderWhenPullToPerformAction:(nonnull SEL)action;
//设置上拉下载
- (void)addTableViewRefreshFooterWhenPullToPerformAction:(nonnull SEL)action;
/*
 *结束下拉刷新
 **/
- (void)endRefresh;
/*
 *结束上拉下载
 **/
-(void)endPullUPRefresh;


@end
