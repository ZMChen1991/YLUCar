//
//  YLSubDetailModel.m
//  YLUCar
//
//  Created by lm on 2019/2/16.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLSubDetailModel.h"

@implementation YLSubDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"carID":@"id", @"descript":@"description"};
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
