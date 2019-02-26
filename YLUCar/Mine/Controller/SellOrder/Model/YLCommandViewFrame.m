//
//  YLCommandViewFrame.m
//  YLUCar
//
//  Created by lm on 2019/2/20.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLCommandViewFrame.h"
#import "YLCommandModel.h"

@implementation YLCommandViewFrame

- (void)setModel:(YLCommandModel *)model {
    _model = model;
    
    if (!model) {
        return;
    }
    
    CGFloat iconW = 120;
    CGFloat iconH = 86;
    self.iconF = CGRectMake(LeftMargin, TopMargin, iconW, iconH);
    CGFloat titleX = CGRectGetMaxX(self.iconF) + LeftMargin;
    CGFloat titleW = YLScreenWidth - 120 - 2 * LeftMargin - TopMargin;
    self.titleF = CGRectMake(titleX, TopMargin, titleW, 34);
    self.courseF = CGRectMake(titleX, CGRectGetMaxY(self.titleF) + 5, titleW, 17);
    CGSize size = [[model.price stringToNumberString] getSizeWithFont:[UIFont systemFontOfSize:18]];
    self.priceF = CGRectMake(titleX, CGRectGetMaxY(self.courseF) + 5, size.width + 10, 25);
    self.originalPriceF = CGRectMake(CGRectGetMaxX(self.priceF), CGRectGetMaxY(self.courseF) + 9, YLScreenWidth - CGRectGetMaxX(self.priceF) - TopMargin, 17);
    self.lineF = CGRectMake(0, CGRectGetMaxY(self.iconF) + LeftMargin, YLScreenWidth, 1);
    
    self.viewHeight = CGRectGetMaxY(self.lineF);
}

@end
