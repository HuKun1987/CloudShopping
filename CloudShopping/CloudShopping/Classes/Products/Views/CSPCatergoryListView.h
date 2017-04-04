//
//  CSPCatergoryListView.h
//  CloudShopping
//
//  Created by 胡坤 on 2017/4/2.
//  Copyright © 2017年 hukun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSPProductType;
@protocol CSPCatergoryListViewDelegate  <NSObject>

@optional
- (void)pclistViewdidSelectProfuctType:(CSPProductType *)productType;
@end

@interface CSPCatergoryListView : UIView
@property(nonatomic,assign)BOOL   isDetailStyle;
@property(nonatomic,strong)NSArray   *productTypeList;
@property(nonatomic,weak)id <CSPCatergoryListViewDelegate>delegate;
@end
