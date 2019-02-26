//
//  YLSellOrderDetailController.h
//  YLUCar
//
//  Created by lm on 2019/2/20.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YLSaleOrderModel;
typedef void(^SellOrderDetaiBlock)(void);

@interface YLSellOrderDetailController : UIViewController

@property (nonatomic, strong) YLSaleOrderModel *model;
@property (nonatomic, copy) SellOrderDetaiBlock sellOrderDetaiBlock;

@end

NS_ASSUME_NONNULL_END
