//
//  YLBuyOrderCellFrame.m
//  YLGoodCard
//
//  Created by lm on 2018/12/2.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLBuyOrderCellFrame.h"

@implementation YLBuyOrderCellFrame

- (void)setModel:(YLBuyOrderModel *)model {
    _model = model;
    
    self.iconF = CGRectMake(LeftMargin, TopMargin, 120, 86);
    
    CGFloat titleX = CGRectGetMaxX(self.iconF) + LeftMargin;
    CGFloat titleW = YLScreenWidth - 120 - 2 * LeftMargin - TopMargin;
    CGFloat priceW = [[self stringToNumber:model.detail.price] getSizeWithFont:[UIFont systemFontOfSize:18]].width + 10;
    self.titleF = CGRectMake(titleX, TopMargin, titleW, 34);
    self.courseF = CGRectMake(titleX, CGRectGetMaxY(self.titleF) + 5, titleW, 17);
    self.lookCarTimeF = CGRectMake(titleX, CGRectGetMaxY(self.titleF)+5, titleW, 17);
    self.priceF = CGRectMake(titleX, CGRectGetMaxY(self.lookCarTimeF) + 5, priceW, 25);
    self.originalPriceF = CGRectMake(CGRectGetMaxX(self.priceF), CGRectGetMaxY(self.lookCarTimeF) + 9, YLScreenWidth - CGRectGetMaxX(self.priceF) - TopMargin, 17);
    //    self.lookCarTimeF = CGRectMake(titleX, CGRectGetMaxY(self.priceF), titleW, 17);
    self.lineF = CGRectMake(0, CGRectGetMaxY(self.iconF)-1 + LeftMargin, YLScreenWidth, 1);
    self.cellHeight = CGRectGetMaxY(self.lineF);
}

- (NSString *)stringToNumber:(NSString *)number {
    
    //    CGFloat priceW = [[self stringToNumber:lookCarModel.detail.price] getSizeWithFont:[UIFont systemFontOfSize:18]].width + 10;
    float count = [number floatValue] / 10000;
    return [NSString stringWithFormat:@"%.2f万",count];
}

@end
