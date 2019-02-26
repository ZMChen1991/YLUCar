//
//  YLLookCarCellFrame.m
//  YLUCar
//
//  Created by lm on 2019/2/19.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLLookCarCellFrame.h"
#import "YLLookCarModel.h"
#import "YLLookCarDetailModel.h"

@implementation YLLookCarCellFrame

- (void)setModel:(YLLookCarModel *)model {
    _model = model;
    
    self.iconF = CGRectMake(LeftMargin, TopMargin, 120, 86);
    CGFloat courseW = YLScreenWidth - 120 - 2 * LeftMargin - TopMargin;
    CGFloat titleX = CGRectGetMaxX(self.iconF) + LeftMargin;
    CGFloat titleW = YLScreenWidth - CGRectGetMaxX(self.iconF) - 2 * LeftMargin;
    CGFloat titleH = 34;
    NSString *price = [self.model.detail.price stringToNumberString];
    CGFloat priceW = [price getSizeWithFont:[UIFont systemFontOfSize:18]].width + TopMargin;
    self.titleF = CGRectMake(titleX, TopMargin, titleW, titleH);
    self.lookCarTimeF = CGRectMake(titleX, CGRectGetMaxY(self.titleF) + 5, courseW, 17);
    self.priceF = CGRectMake(titleX, CGRectGetMaxY(self.lookCarTimeF) + 5, priceW, 25);
    self.originalPriceF = CGRectMake(CGRectGetMaxX(self.priceF), CGRectGetMaxY(self.lookCarTimeF) + 5, YLScreenWidth - CGRectGetMaxX(self.priceF) - 15 , 25);
    self.lineF = CGRectMake(0, CGRectGetMaxY(self.iconF) + TopMargin, YLScreenWidth, 1);
    self.cellHeight = CGRectGetMaxY(self.lineF);
}

@end
