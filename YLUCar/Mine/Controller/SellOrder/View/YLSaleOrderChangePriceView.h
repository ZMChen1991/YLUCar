//
//  YLSaleOrderChangePriceView.h
//  YLUCar
//
//  Created by lm on 2019/2/22.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YLSaleOrderChangePriceViewDelegate <NSObject>

- (void)cancelChangePrice;
- (void)sureWithPrice:(NSString *)price floorPrice:(NSString *)floorPrice isAccept:(BOOL)isAccept;

@end

@interface YLSaleOrderChangePriceView : UIView

@property (nonatomic, weak) id<YLSaleOrderChangePriceViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
