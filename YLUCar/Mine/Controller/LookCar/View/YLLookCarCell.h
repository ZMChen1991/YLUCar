//
//  YLLookCarCell.h
//  YLUCar
//
//  Created by lm on 2019/2/19.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YLLookCarCellFrame;
NS_ASSUME_NONNULL_BEGIN

@interface YLLookCarCell : UITableViewCell

@property (nonatomic, strong) YLLookCarCellFrame *cellFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
