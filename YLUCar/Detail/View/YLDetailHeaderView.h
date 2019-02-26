//
//  YLDetailHeaderView.h
//  YLUCar
//
//  Created by lm on 2019/2/15.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YLDetailModel;

NS_ASSUME_NONNULL_BEGIN
@protocol YLDetailHeaderViewDelegate <NSObject>

- (void)priceRemind;
- (void)bargain;
- (void)clickToPictureModelInIndex:(NSInteger)index;

@end

@interface YLDetailHeaderView : UIView

//@property (nonatomic, strong) YLDetailModel *detailModel;
@property (nonatomic, strong) NSDictionary *detail;
@property (nonatomic, weak) id<YLDetailHeaderViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
