//
//  YLTabBarController.h
//  YLUCar
//
//  Created by lm on 2019/1/28.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLTabBarController : UITabBarController

- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage;

@end

NS_ASSUME_NONNULL_END
