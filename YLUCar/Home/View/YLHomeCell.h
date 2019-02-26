//
//  YLHomeCell.h
//  YLUCar
//
//  Created by lm on 2019/1/28.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLCommandCellFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLHomeCell : UITableViewCell

@property (nonatomic, strong) YLCommandCellFrame *cellFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
