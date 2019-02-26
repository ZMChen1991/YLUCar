//
//  YLBrandItemView.h
//  YLUCar
//
//  Created by lm on 2019/1/29.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YLConditionParamModel;
@protocol YLBrandItemViewDelegate <NSObject>

- (void)choiceBrand:(YLConditionParamModel *)model;

@end

@interface YLBrandItemView : UIView

@property (nonatomic, weak) id<YLBrandItemViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
