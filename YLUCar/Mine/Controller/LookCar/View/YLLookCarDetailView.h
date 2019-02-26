//
//  YLLookCarDetailView.h
//  YLUCar
//
//  Created by lm on 2019/2/22.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YLDetectCenterModel;
NS_ASSUME_NONNULL_BEGIN

@interface YLLookCarDetailView : UIView

@property (nonatomic, strong) YLDetectCenterModel *model;
@property (nonatomic, strong) NSString *appointTime;

@end

NS_ASSUME_NONNULL_END
