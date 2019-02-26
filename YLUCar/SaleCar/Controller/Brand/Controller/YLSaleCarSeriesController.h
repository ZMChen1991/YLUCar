//
//  YLSaleCarSeriesController.h
//  YLUCar
//
//  Created by lm on 2019/2/14.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLBrandModel.h"
@class YLSeriesModel;
@class YLCarTypeModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SeriesBlock)(YLSeriesModel *seriesModel, YLCarTypeModel *carTypeModel);

@interface YLSaleCarSeriesController : UITableViewController

@property (nonatomic, strong) YLBrandModel *model;
@property (nonatomic, copy) SeriesBlock seriesBlock;

@end

NS_ASSUME_NONNULL_END
