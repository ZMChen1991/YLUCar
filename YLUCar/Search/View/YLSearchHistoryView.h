//
//  YLSearchHistoryView.h
//  YLUCar
//
//  Created by lm on 2019/2/26.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//typedef void(^SearchBlock)(NSString *searchTitle);
@protocol YLSearchHistoryViewDelegate <NSObject>

- (void)searchTitle:(NSString *)searchTitle;
- (void)clearSearchHistory;

@end

@interface YLSearchHistoryView : UIView

@property (nonatomic, strong) NSMutableArray *searchHistory;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isHideDelete;
@property (nonatomic, assign) CGFloat viewHeight;

//@property (nonatomic, copy) SearchBlock searchBlock;
@property (nonatomic, weak) id<YLSearchHistoryViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
