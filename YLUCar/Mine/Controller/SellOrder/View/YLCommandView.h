//
//  YLCommandView.h
//  YLUCar
//
//  Created by lm on 2019/2/20.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YLCommandViewFrame;
NS_ASSUME_NONNULL_BEGIN

//typedef void(^CommandViewBlock)(void);
@protocol YLCommandViewDelegate <NSObject>

- (void)clickCommandView;

@end
@interface YLCommandView : UIView

@property (nonatomic, strong) YLCommandViewFrame *viewFrame;
//@property (nonatomic, copy) CommandViewBlock commandViewBlock;
@property (nonatomic, weak) id<YLCommandViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
