//
//  YLSubSellerBargainHistoryCell.h
//  YLGoodCard
//
//  Created by lm on 2018/12/13.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLBargainHistoryCellFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLSubSellerBargainHistoryCell : UITableViewCell

@property (nonatomic, strong) YLBargainHistoryCellFrame *cellFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
