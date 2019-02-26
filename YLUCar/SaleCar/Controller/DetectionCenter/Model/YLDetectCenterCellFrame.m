//
//  YLDetectCenterCellFrame.m
//  YLGoodCard
//
//  Created by lm on 2019/1/21.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLDetectCenterCellFrame.h"

@implementation YLDetectCenterCellFrame

- (void)setModel:(YLDetectCenterModel *)model {
    _model = model;
    
    CGFloat labelW = YLScreenWidth - 2 * LeftMargin;
    CGFloat labelH = 22;
    self.centerF = CGRectMake(LeftMargin, LeftMargin, labelW, labelH);
    NSString *address = [NSString stringWithFormat:@"地址:%@", model.address];
    CGSize addressSize = [address getSizeWithFont:[UIFont systemFontOfSize:14]];
    CGFloat addressH = 20.0f;
    CGFloat height = 20.0f;
    if (addressSize.width > labelW) {
        addressH = 40.0f;
    }
    self.addressF = CGRectMake(LeftMargin, CGRectGetMaxY(self.centerF) + 5, labelW, addressH);
    self.telephoneF = CGRectMake(LeftMargin, CGRectGetMaxY(self.addressF) + 5, labelW, height);
    self.lineF = CGRectMake(0, CGRectGetMaxY(self.telephoneF) + LeftMargin, YLScreenWidth, 1);
    self.cellHeight = CGRectGetMaxY(self.lineF);
}

@end
