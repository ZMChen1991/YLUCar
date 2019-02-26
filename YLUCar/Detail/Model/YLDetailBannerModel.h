//
//  YLDetailBannerModel.h
//  YLUCar
//
//  Created by lm on 2019/2/16.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLDetailBannerModel : NSObject

@property (nonatomic, assign) NSInteger sortNo;
@property (nonatomic, strong) NSString *detailId;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *imageID;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *createAt;
@property (nonatomic, strong) NSString *group;
@property (nonatomic, strong) NSString *updateAt;

@end

NS_ASSUME_NONNULL_END
