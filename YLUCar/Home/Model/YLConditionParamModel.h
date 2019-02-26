//
//  YLConditionParamModel.h
//  YLUCar
//
//  Created by lm on 2019/1/29.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLConditionParamModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *param;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *detailTitle;
@property (nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
