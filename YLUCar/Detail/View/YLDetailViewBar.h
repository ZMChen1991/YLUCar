//
//  YLDetailViewBar.h
//  YLUCar
//
//  Created by lm on 2019/2/16.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YLDetailModel;
NS_ASSUME_NONNULL_BEGIN

@protocol YLDetailViewBarDelegate <NSObject>

- (void)consultCustom;
- (void)collectCar;
- (void)bargainPrice;
- (void)orderLookCar;

@end

@interface YLDetailViewBar : UIView

@property (nonatomic, weak) id<YLDetailViewBarDelegate> delegate;
@property (nonatomic, strong) YLDetailModel *model;
@end

NS_ASSUME_NONNULL_END
