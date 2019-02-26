//
//  YLLoginController.h
//  YLUCar
//
//  Created by lm on 2019/2/11.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YLLoginBlock)(NSString *telephone);

@interface YLLoginController : UIViewController

@property (nonatomic, copy) YLLoginBlock loginBlock;

@end

NS_ASSUME_NONNULL_END
