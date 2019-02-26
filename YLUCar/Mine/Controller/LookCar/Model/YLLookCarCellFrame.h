//
//  YLLookCarCellFrame.h
//  YLUCar
//
//  Created by lm on 2019/2/19.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YLLookCarModel;
NS_ASSUME_NONNULL_BEGIN

@interface YLLookCarCellFrame : NSObject

@property (nonatomic, strong) YLLookCarModel *model;

@property (nonatomic, assign) CGRect iconF;
@property (nonatomic, assign) CGRect titleF;
@property (nonatomic, assign) CGRect priceF;
@property (nonatomic, assign) CGRect originalPriceF;
@property (nonatomic, assign) CGRect lookCarTimeF;
@property (nonatomic, assign) CGRect lineF;

@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
