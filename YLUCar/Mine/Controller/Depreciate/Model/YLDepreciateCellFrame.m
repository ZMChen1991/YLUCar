//
//  YLDepreciateCellFrame.m
//  YLGoodCard
//
//  Created by lm on 2018/12/2.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLDepreciateCellFrame.h"

@implementation YLDepreciateCellFrame

- (void)setModel:(YLDepreciateModel *)model {
    
    _model = model;
    CGFloat iconW = 120;
    CGFloat iconH = 86;
    self.iconF = CGRectMake(LeftMargin, TopMargin, iconW, iconH);
    CGFloat titleX = CGRectGetMaxX(self.iconF) + LeftMargin;
    CGFloat titleW = YLScreenWidth - iconW - 2 * LeftMargin - TopMargin;
    CGFloat titleH = 34;
    self.titleF = CGRectMake(titleX, TopMargin, titleW, titleH);
    self.courseF = CGRectMake(titleX, CGRectGetMaxY(self.titleF) + 5, titleW, 17);
    self.priceF = CGRectMake(titleX, CGRectGetMaxY(self.courseF) + 5, titleW / 3, 25);
    CGFloat downW = 16.f;
    self.downF = CGRectMake(CGRectGetMaxX(self.priceF), CGRectGetMaxY(self.courseF) + TopMargin, downW, downW);
    self.depreciateF = CGRectMake(CGRectGetMaxX(self.downF) + 5, CGRectGetMaxY(self.courseF) + TopMargin, YLScreenWidth - CGRectGetMaxX(self.downF) - TopMargin, 17);
    self.lineF = CGRectMake(0, CGRectGetMaxY(self.iconF)-1 + LeftMargin, YLScreenWidth, 1);
    self.cellHeight = CGRectGetMaxY(self.lineF);
}

@end
