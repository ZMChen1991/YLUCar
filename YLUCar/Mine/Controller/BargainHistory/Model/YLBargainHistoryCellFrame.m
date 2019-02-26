//
//  YLBargainHistoryCellFrame.m
//  YLGoodCard
//
//  Created by lm on 2018/12/2.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLBargainHistoryCellFrame.h"

@implementation YLBargainHistoryCellFrame

- (void)setModel:(YLBargainHistoryModel *)model {
    _model = model;
    
    self.iconF = CGRectMake(LeftMargin, TopMargin, 120, 86);
    
    CGSize priceSize = [[self stringToNumber:model.detail.price] getSizeWithFont:[UIFont systemFontOfSize:18]];
    CGFloat priceW = priceSize.width + 10;
    float titleX = CGRectGetMaxX(self.iconF) + LeftMargin;
    float titleW = YLScreenWidth - 120 - 2 * LeftMargin - TopMargin;
    self.titleF = CGRectMake(titleX, TopMargin, titleW, 17);
    self.courseF = CGRectMake(titleX, CGRectGetMaxY(self.titleF) + 5, titleW, 17);
    self.priceF = CGRectMake(titleX, CGRectGetMaxY(self.courseF) + 5, priceW, 25);
    self.originalPriceF = CGRectMake(CGRectGetMaxX(self.priceF), CGRectGetMaxY(self.courseF) + 9, YLScreenWidth - CGRectGetMaxX(self.priceF) - TopMargin, 17);
    self.messageF = CGRectMake(titleX, CGRectGetMaxY(self.priceF) + 5, titleW, 17);
    self.bargainNumberF = CGRectMake(YLScreenWidth - 36 - 15, 40, 36, 36);
    self.soldOutF = CGRectMake(YLScreenWidth - 60 - 15, 40, 60, 60);
    self.lineF = CGRectMake(0, CGRectGetMaxY(self.iconF)-1 + LeftMargin, YLScreenWidth, 1);
    self.cellHeight = CGRectGetMaxY(self.lineF);
}

- (NSString *)stringToNumber:(NSString *)number {
    
    float count = [number floatValue] / 10000;
    return [NSString stringWithFormat:@"%.2f万",count];
}

@end
