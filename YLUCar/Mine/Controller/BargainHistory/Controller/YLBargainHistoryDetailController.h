//
//  YLBargainHistoryDetailController.h
//  YLUCar
//
//  Created by lm on 2019/2/21.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YLBargainHistoryModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^BargainHistoryDetailBlock)(void);
@interface YLBargainHistoryDetailController : UITableViewController

@property (nonatomic, strong) YLBargainHistoryModel *model;
@property (nonatomic, assign) BOOL isBuyer;

@property (nonatomic, copy) BargainHistoryDetailBlock bargainHistoryDetailBlock;

@end

NS_ASSUME_NONNULL_END
