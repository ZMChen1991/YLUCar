//
//  YLNoneView.h
//  YLGoodCard
//
//  Created by lm on 2018/11/19.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YLNoneViewDelegate <NSObject>

- (void)reloadData;

@end
@interface YLNoneView : UIView

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, weak) id<YLNoneViewDelegate> delegate;

- (void)hideBtn;

@end

NS_ASSUME_NONNULL_END
