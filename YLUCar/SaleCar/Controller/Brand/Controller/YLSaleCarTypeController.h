//
//  YLSaleCarTypeController.h
//  YLUCar
//
//  Created by lm on 2019/2/14.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  YLSeriesModel;
@class YLCarTypeModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^CarTypeBlock)(YLCarTypeModel *carTypeModel);

@interface YLSaleCarTypeController : UITableViewController

@property (nonatomic, strong) YLSeriesModel *seriesModel;
@property (nonatomic, copy) CarTypeBlock carTypeBlock;

@end

NS_ASSUME_NONNULL_END
