//
//  CSRootTabBarController.m
//  CloudShopping
//
//  Created by 胡坤 on 2017/4/2.
//  Copyright © 2017年 hukun. All rights reserved.
//

#import "CSRootTabBarController.h"
#import "CSBaseNavigationController.h"
#import "CSHomeViewController.h"
#import "CSProductsController.h"
#import "CSLatestViewController.h"
#import "CSShopCartController.h"
#import "CSMineViewController.h"
@interface CSRootTabBarController ()

@end

@implementation CSRootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self rootTabBarControllerAddControllers];
}

- (void)rootTabBarControllerAddControllers{
    NSMutableArray *controllerArrM = [NSMutableArray arrayWithCapacity:4];
    [controllerArrM addObject:[self addChildController:@"CSHomeViewController" Title:@"首页" TabBarImageName:@""]];
    [controllerArrM  addObject:[self addChildController:@"CSProductsController" Title:@"所有商品" TabBarImageName:@""]];
    [controllerArrM addObject:[self addChildController:@"CSLatestViewController" Title:@"最新揭晓" TabBarImageName:@""]];
    [controllerArrM addObject:[self addChildController:@"CSShopCartController" Title:@"购物车" TabBarImageName:@""]];
    [controllerArrM addObject:[self addChildController:@"CSMineViewController" Title:@"我的云购" TabBarImageName:@""]];
    
    self.viewControllers = controllerArrM.copy;
    self.tabBar.tintColor = [UIColor orangeColor];
}

- (UIViewController *)addChildController:(NSString *)controllerName Title:(NSString *) title TabBarImageName:(NSString *)imgName{
    Class controllerClass = NSClassFromString(controllerName);
    NSAssert([controllerClass isSubclassOfClass:[UIViewController class]], @"%@不是一个控制器的类",controllerName);
        UIViewController *viewController = [controllerClass  new];
        if (title) {
            viewController.title = title;
        }
        if (imgName) {
            UIImage *normalImg = [UIImage imageNamed:imgName];
            UIImage *selectedImg = [[UIImage imageNamed:[NSString stringWithFormat:@"%@",imgName]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            viewController.tabBarItem.image = normalImg;
            viewController.tabBarItem.selectedImage = selectedImg;
        }
        
        return [[CSBaseNavigationController alloc]initWithRootViewController:viewController];

}
@end
