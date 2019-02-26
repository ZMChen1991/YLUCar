//
//  YLCommandModel.h
//  YLUCar
//
//  Created by lm on 2019/1/28.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLCommandModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *carID;
@property (nonatomic, strong) NSString *displayImg;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *course;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *originalPrice;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *licenseTime;

@end

NS_ASSUME_NONNULL_END
