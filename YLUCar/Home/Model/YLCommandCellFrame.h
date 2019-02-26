//
//  YLCommandCellFrame.h
//  YLUCar
//
//  Created by lm on 2019/1/28.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLCommandModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLCommandCellFrame : NSObject

@property (nonatomic, assign) CGRect displayImgF;
@property (nonatomic, assign) CGRect titleF;
@property (nonatomic, assign) CGRect courseF;
@property (nonatomic, assign) CGRect priceF;
@property (nonatomic, assign) CGRect originalPriceF;
@property (nonatomic, assign) CGRect lineF;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL isLargeImage;

@property (nonatomic, strong) YLCommandModel *model;

@end

NS_ASSUME_NONNULL_END
