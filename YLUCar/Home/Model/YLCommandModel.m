//
//  YLCommandModel.m
//  YLUCar
//
//  Created by lm on 2019/1/28.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLCommandModel.h"

@implementation YLCommandModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"carID":@"id"};
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.carID forKey:@"carID"];
    [aCoder encodeObject:self.displayImg forKey:@"displayImg"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.course forKey:@"course"];
    [aCoder encodeObject:self.price forKey:@"price"];
    [aCoder encodeObject:self.originalPrice forKey:@"originalPrice"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.licenseTime forKey:@"licenseTime"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        self.carID = [aDecoder decodeObjectForKey:@"carID"];
        self.displayImg = [aDecoder decodeObjectForKey:@"displayImg"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.course = [aDecoder decodeObjectForKey:@"course"];
        self.price = [aDecoder decodeObjectForKey:@"price"];
        self.originalPrice = [aDecoder decodeObjectForKey:@"originalPrice"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.licenseTime = [aDecoder decodeObjectForKey:@"licenseTime"];
    }
    return self;
}

@end
