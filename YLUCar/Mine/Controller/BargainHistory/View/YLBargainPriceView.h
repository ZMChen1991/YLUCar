//
//  YLBargainPriceView.h
//  YLUCar
//
//  Created by lm on 2019/2/21.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YLBargainPriceViewDelegate <NSObject>

- (void)cancelBargainPrice;
- (void)sureBargainPrice:(NSString *)bargainPrice;

@end

@interface YLBargainPriceView : UIView

@property (nonatomic, weak) id<YLBargainPriceViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
