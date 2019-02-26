//
//  YLTabBarController.m
//  YLUCar
//
//  Created by lm on 2019/1/28.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLTabBarController.h"
#import "YLNavigationController.h"
#import "YLHomeController.h"
#import "YLBuyCarController.h"
#import "YLSaleCarController.h"

@interface YLTabBarController ()

@end

@implementation YLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    YLHomeController *home = [[YLHomeController alloc] init];
//    [self addChildViewController:home title:@"首页" image:@"" selectImage:@""];
//    
//    YLBuyCarController *buyCar = [[YLBuyCarController alloc] init];
//    [self addChildViewController:buyCar title:@"买车" image:@"" selectImage:@""];
//    
//    YLSaleCarController *saleCar = [[YLSaleCarController alloc] init];
//    [self addChildViewController:saleCar title:@"卖车" image:@"" selectImage:@""];
    
}

- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage {
    
    childController.title = title;
    childController.tabBarItem.image = [UIImage imageNamed:image];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 调节tabBarItem的文字位置
    childController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -10);
    YLNavigationController *nav = [[YLNavigationController alloc] initWithRootViewController:childController];
    
    // 在此修改tabBarItem的文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = YLColor(21.f, 126.f, 251.f);
    [nav.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [nav.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    [self addChildViewController:nav];
    
}

@end
