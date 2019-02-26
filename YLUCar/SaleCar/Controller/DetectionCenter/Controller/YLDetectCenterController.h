//
//  YLDetectCenterController.h
//  YLUCar
//
//  Created by lm on 2019/2/14.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YLDetectCenterModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^DetectCenterBlock)(YLDetectCenterModel *model);

@interface YLDetectCenterController : UITableViewController

@property (nonatomic, strong) NSString *city;
@property (nonatomic, copy) DetectCenterBlock detectCenterBlock;
@end

NS_ASSUME_NONNULL_END
