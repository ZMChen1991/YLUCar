//
//  YLCollectionDetailModel.m
//  YLUCar
//
//  Created by lm on 2019/2/19.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLCollectionDetailModel.h"

@implementation YLCollectionDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"carID":@"id"};
}

@end
