//
//  YLContactView.h
//  YLUCar
//
//  Created by lm on 2019/2/21.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLBuyOrderModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol YlContactViewDelegate <NSObject>

- (void)contactCustomer;

@end
@interface YLContactView : UIView

@property (nonatomic, weak) id<YlContactViewDelegate> delegate;
@property (nonatomic, strong) YLBuyOrderModel *model;

@end

NS_ASSUME_NONNULL_END
