//
//  YLCustomPrice.h
//  YLGoodCard
//
//  Created by lm on 2018/11/7.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CustomPriceBlock)(NSArray *priceModels);
typedef void(^SurePriceBlock)(NSString *lowPrice, NSString *highPrice);


@interface YLCustomPrice : UIView

@property (nonatomic, copy) CustomPriceBlock customPriceBlock;
@property (nonatomic, copy) SurePriceBlock surePriceBlock;

@property (nonatomic, copy) NSArray *models;
//@property (nonatomic, strong) YLConditionParamModel *lowModel;
//@property (nonatomic, strong) YLConditionParamModel *highModel;


@end
