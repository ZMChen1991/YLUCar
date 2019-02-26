//
//  YLNavigationController.m
//  YLUCar
//
//  Created by lm on 2019/1/28.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLNavigationController.h"

@interface YLNavigationController ()

@end

@implementation YLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 修改导航标题大小与颜色
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    // 设置导航栏左右两边的文字颜色
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    // 设置导航栏背景图片
    [self.navigationBar setBackgroundImage:[self setNavgationBarBackgroundImage] forBarMetrics:UIBarMetricsDefault];
    // 设置导航栏底部线条为空
    [self.navigationBar setShadowImage:[UIImage new]];
}

- (UIImage *)setNavgationBarBackgroundImage {
    CGGradientRef gradient;// 颜色的空间
    size_t num_locations = 2;// 渐变中使用的颜色数
    CGFloat locations[] = {0.0, 1.0}; // 指定每个颜色在渐变色中的位置，值介于0.0-1.0之间, 0.0表示最开始的位置，1.0表示渐变结束的位置
    CGFloat colors[] = {
        13.0/255.0, 196.f/255.f, 255.f/255, 1.0,
        3.0/255.0, 141.f/255.f, 255.f/255, 1.0,
    }; // 指定渐变的开始颜色，终止颜色，以及过度色（如果有的话）
    gradient = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(), colors, locations, num_locations);
    CGPoint startPoint = CGPointMake(0.0, 0.0);
    CGPoint endPoint = CGPointMake(self.view.frame.size.width, 1.0);
    CGSize size = CGSizeMake(self.view.frame.size.width, 1.0);
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    NSLog(@"%f-%f", image.size.width, image.size.height);
    return image;
}

/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
        /* 设置导航栏上面的内容 */
        // 设置左边的返回按钮
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, 0, 50, 30);
        leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
        [leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateHighlighted];
        [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        UIBarButtonItem *nagetiveSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        nagetiveSpace.width = -50;
        viewController.navigationItem.leftBarButtonItems = @[nagetiveSpace, leftBarButtonItem];
        
        
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHTABLEVIEW" object:nil];
    // 因为self本来就是一个导航控制器，self.navigationController这里是nil的
    [self popViewControllerAnimated:YES];
}
@end
