//
//  YLCollectionModel.h
//  YLGoodCard
//
//  Created by lm on 2018/11/30.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YLCollectionDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface YLCollectionModel : NSObject

@property (nonatomic, strong) YLCollectionDetailModel *detail;
@property (nonatomic, strong) NSString *createAt;
@property (nonatomic, strong) NSString *detailId;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *telephone;

@end

NS_ASSUME_NONNULL_END
