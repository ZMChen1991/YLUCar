//
//  YLCollectionCarCell.h
//  YLUCar
//
//  Created by lm on 2019/2/19.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLCollectCellFrame;
NS_ASSUME_NONNULL_BEGIN

@interface YLCollectionCarCell : UITableViewCell

@property (nonatomic, strong) YLCollectCellFrame *cellFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
