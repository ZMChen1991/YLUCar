//
//  YLBarView.h
//  Block
//
//  Created by lm on 2018/12/21.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YLBarViewDelegate <NSObject>

- (void)pushSearchController;

@end
@interface YLBarView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *icon;

@property (nonatomic, weak) id<YLBarViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
