//
//  YLBuyOrderCellFrame.h
//  YLGoodCard
//
//  Created by lm on 2018/12/2.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLBuyOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLBuyOrderCellFrame : NSObject

@property (nonatomic, strong) YLBuyOrderModel *model;

@property (nonatomic, assign) CGRect iconF;
@property (nonatomic, assign) CGRect titleF;
@property (nonatomic, assign) CGRect courseF;
@property (nonatomic, assign) CGRect priceF;
@property (nonatomic, assign) CGRect originalPriceF;
@property (nonatomic, assign) CGRect lookCarTimeF;
@property (nonatomic, assign) CGRect lineF;

@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
