//
//  YLCommandViewFrame.h
//  YLUCar
//
//  Created by lm on 2019/2/20.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YLCommandModel;
NS_ASSUME_NONNULL_BEGIN

@interface YLCommandViewFrame : NSObject

@property (nonatomic, strong) YLCommandModel *model;

@property (nonatomic, assign) CGRect iconF; // 图片
@property (nonatomic, assign) CGRect titleF; // 名称
@property (nonatomic, assign) CGRect courseF; // 年/万公里
@property (nonatomic, assign) CGRect priceF; // 销售价格
@property (nonatomic, assign) CGRect originalPriceF; // 新车价
@property (nonatomic, assign) CGRect lineF;

@property (nonatomic, assign) CGFloat viewHeight;

@end

NS_ASSUME_NONNULL_END
