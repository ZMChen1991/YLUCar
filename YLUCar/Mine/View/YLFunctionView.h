//
//  YLFunctionView.h
//  YLUCar
//
//  Created by lm on 2019/2/13.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YLFunctionViewDelegate <NSObject>

- (void)numberViewClickAtIndex:(NSInteger)index;
- (void)customBtnClickAtIndex:(NSInteger)index;

@end


@interface YLFunctionView : UIView

@property (nonatomic, strong) NSArray *numbers; // 即将看车、我的收藏、浏览记录、我的订阅的个数
@property (nonatomic, strong) NSString *depreciateNumber;// 降价提醒数量
@property (nonatomic, strong) NSString *bargainNumber;// 砍价数量

@property (nonatomic, weak) id<YLFunctionViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
