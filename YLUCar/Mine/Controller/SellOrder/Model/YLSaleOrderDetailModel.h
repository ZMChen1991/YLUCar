//
//  YLSaleOrderDetailModel.h
//  YLGoodCard
//
//  Created by lm on 2018/12/1.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLSaleOrderDetailModel : NSObject

@property (nonatomic, strong) NSString *carID;
@property (nonatomic, strong) NSString *clickSum;
@property (nonatomic, strong) NSString *displayImg;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *lookSum;
@property (nonatomic, strong) NSString *course;
@property (nonatomic, strong) NSString *originalPrice;
@property (nonatomic, strong) NSString *floorPrice;
@property (nonatomic, strong) NSString *centerId;
@property (nonatomic, strong) NSString *licenseTime;
@property (nonatomic, strong) NSString *status;

@end

NS_ASSUME_NONNULL_END
