//
//  YLOrderCarDetailView.h
//  YLUCar
//
//  Created by lm on 2019/2/21.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YLOrderCarDetailViewDelegate <NSObject>

- (void)orderCarTime:(NSString *)time;
- (void)orderCarCancel;

@end

typedef void(^OrderCarDetailCancelBlock)(void);
typedef void(^OrderCarDetailSureBlock)(NSString *orderCarTime);

@interface YLOrderCarDetailView : UIView

@property (nonatomic, weak) id<YLOrderCarDetailViewDelegate> delegate;
@property (nonatomic, copy) OrderCarDetailCancelBlock orderCarDetailCancelBlock;
@property (nonatomic, copy) OrderCarDetailSureBlock orderCarDetailSureBlock;


@end

NS_ASSUME_NONNULL_END
