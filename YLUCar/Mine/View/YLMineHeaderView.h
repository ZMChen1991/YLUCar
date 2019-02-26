//
//  YLMineHeaderView.h
//  YLUCar
//
//  Created by lm on 2019/2/13.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YLMineHeaderViewType) {
    YLMineHeaderViewTypeLogout,
    YLMineHeaderViewTypeLogin,
};

@protocol YLMineHeaderViewDelegate <NSObject>

- (void)skipLoginController;

@end

@interface YLMineHeaderView : UIView

@property (nonatomic, assign) YLMineHeaderViewType type;
@property (nonatomic, weak) id<YLMineHeaderViewDelegate> delegate;
@property (nonatomic, strong) NSString *telephone;

@end

NS_ASSUME_NONNULL_END
