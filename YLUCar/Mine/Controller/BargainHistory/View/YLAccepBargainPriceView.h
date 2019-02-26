//
//  YLAccepBargainPriceView.h
//  YLUCar
//
//  Created by lm on 2019/2/21.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YLAccepBargainPriceViewDelegate <NSObject>

@optional
- (void)cancelAccept;
- (void)sureAccept;
//- (void)surePutaway;
//- (void)sureSoldOut;

@end

@interface YLAccepBargainPriceView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, weak) id<YLAccepBargainPriceViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
