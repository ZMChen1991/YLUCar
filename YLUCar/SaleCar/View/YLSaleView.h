//
//  YLSaleView.h
//  YLGoodCard
//
//  Created by lm on 2018/11/2.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AppraiseBlock)(void);
typedef void(^ConsultBlock)(void);
typedef void(^SaleCarBlock)(void);

@interface YLSaleView : UIView

@property (nonatomic, strong) NSString *telephone;// 预约卖车电话
@property (nonatomic, strong) NSString *salerNum;// 卖车数

@property (nonatomic, copy) AppraiseBlock appraiseBlock;
@property (nonatomic, copy) ConsultBlock consultBlock;
@property (nonatomic, copy) SaleCarBlock saleCarBlock;

@end
