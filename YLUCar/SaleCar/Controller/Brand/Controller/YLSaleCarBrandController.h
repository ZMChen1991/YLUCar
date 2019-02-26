//
//  YLSaleCarBrandController.h
//  YLUCar
//
//  Created by lm on 2019/2/14.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLBrandModel, YLSeriesModel, YLCarTypeModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^BrandBlock)(YLBrandModel *brandModel, YLSeriesModel *seriesModel, YLCarTypeModel *carTypeModel);

@interface YLSaleCarBrandController : UITableViewController

@property (nonatomic, copy) BrandBlock brandBlock;

@end

NS_ASSUME_NONNULL_END
