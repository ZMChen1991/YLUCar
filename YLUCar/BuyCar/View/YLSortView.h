//
//  YLSortView.h
//  YLGoodCard
//
//  Created by lm on 2018/11/10.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class YLSortView;
@class YLConditionParamModel;

@protocol YLSortViewDelegate <NSObject>

- (void)didSelectSort:(NSArray *)models;

@end

typedef void(^SortViewBlock)(NSArray *sortModels);
@interface YLSortView : UIView

@property (nonatomic, weak) id<YLSortViewDelegate> delegate;
@property (nonatomic, copy) SortViewBlock sortViewBlock;

@property (nonatomic, strong) NSArray *models;// 数据源


@end
