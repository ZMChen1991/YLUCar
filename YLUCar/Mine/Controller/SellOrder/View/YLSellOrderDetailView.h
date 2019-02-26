//
//  YLSellOrderDetailView.h
//  YLUCar
//
//  Created by lm on 2019/2/20.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YLSaleOrderModel;
NS_ASSUME_NONNULL_BEGIN

@protocol YLSellOrderDetailViewDelegate <NSObject>

- (void)checkCarDetail;
- (void)sellOrderDetailChangePrice;
- (void)sellOrderDetailSoldOut;
- (void)sellOrderDetailPutaway;

@end

@interface YLSellOrderDetailView : UIView

@property (nonatomic, strong) YLSaleOrderModel *model;
@property (nonatomic, weak) id<YLSellOrderDetailViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
