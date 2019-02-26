//
//  YLDetailModel.h
//  YLUCar
//
//  Created by lm on 2019/2/16.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YLSubDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface YLDetailModel : NSObject

@property (nonatomic, strong) NSString *isBook;
@property (nonatomic, strong) YLSubDetailModel *detail;
@property (nonatomic, strong) NSString *isCollect;
@property (nonatomic, strong) NSDictionary *image;
@property (nonatomic, strong) NSString *report;

@end

NS_ASSUME_NONNULL_END
