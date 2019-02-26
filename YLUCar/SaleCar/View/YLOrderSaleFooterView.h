//
//  YLOrderSaleFooterView.h
//  YLUCar
//
//  Created by lm on 2019/2/14.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YLOrderSaleFooterViewDelegate <NSObject>

- (void)orderSaleInFooterView;
- (void)freeConsultationInFooterView;
@end

@interface YLOrderSaleFooterView : UIView

@property (nonatomic, weak) id<YLOrderSaleFooterViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
