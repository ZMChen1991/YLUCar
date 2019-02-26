//
//  YLSeriesController.h
//  YLGoodCard
//
//  Created by lm on 2018/11/22.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLBrandModel.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^BuySeriesBlock)(NSString *series);

@interface YLSeriesController : UITableViewController

@property (nonatomic, strong) YLBrandModel *model;
@property (nonatomic, copy) BuySeriesBlock buySeriesBlock;

@end

NS_ASSUME_NONNULL_END
