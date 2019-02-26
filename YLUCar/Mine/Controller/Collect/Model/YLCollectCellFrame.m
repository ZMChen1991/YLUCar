//
//  YLCollectCellFrame.m
//  YLGoodCard
//
//  Created by lm on 2018/11/30.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLCollectCellFrame.h"
#import "YLCollectionModel.h"
#import "YLCollectionDetailModel.h"

@implementation YLCollectCellFrame

- (void)setModel:(YLCollectionModel *)model {
    _model = model;
    
    CGFloat width = YLScreenWidth;
    CGFloat iconW = 120;
    CGFloat iconH = 86;
    self.iconF = CGRectMake(LeftMargin, TopMargin, iconW, iconH);
    CGFloat titleX = CGRectGetMaxX(self.iconF) + LeftMargin;
    CGFloat titleW = width - 120 - 2 * LeftMargin - TopMargin;
    CGFloat priceW = [[model.detail.price stringToNumberString] getSizeWithFont:[UIFont systemFontOfSize:18]].width + 10;
    self.titleF = CGRectMake(titleX, TopMargin, titleW, 34);
    self.courseF = CGRectMake(titleX, CGRectGetMaxY(self.titleF) + 5, titleW, 17);
    self.priceF = CGRectMake(titleX, CGRectGetMaxY(self.courseF) + 5, priceW, 25);
    self.originalPriceF = CGRectMake(CGRectGetMaxX(self.priceF), CGRectGetMaxY(self.courseF) + 9, width - CGRectGetMaxX(self.priceF) - TopMargin, 17);
    self.lineF = CGRectMake(0, CGRectGetMaxY(self.iconF)-1 + LeftMargin, width, 1);
    self.cellHeight = CGRectGetMaxY(self.lineF);
}

@end
