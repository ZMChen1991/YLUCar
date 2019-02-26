//
//  YLReportCell.h
//  YLUCar
//
//  Created by lm on 2019/2/15.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YLSubDetailModel;
NS_ASSUME_NONNULL_BEGIN

@protocol YLReportCellDelegate <NSObject>

- (void)reportCellConsult;

@end

@interface YLReportCell : UITableViewCell

@property (nonatomic, weak) id<YLReportCellDelegate> delegate;
@property (nonatomic, strong) YLSubDetailModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
