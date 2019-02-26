//
//  YLOrderSaleFooterView.m
//  YLUCar
//
//  Created by lm on 2019/2/14.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLOrderSaleFooterView.h"
#import "YLCondition.h"

@implementation YLOrderSaleFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat btnH = 40.f;
        CGFloat btnW = frame.size.width - 2 * LeftMargin;
        YLCondition *orderBtn = [YLCondition buttonWithType:UIButtonTypeCustom];
        orderBtn.frame = CGRectMake(LeftMargin, LeftMargin, btnW, btnH);
        orderBtn.type = YLConditionTypeBlue;
        [orderBtn setTitle:@"预约卖车" forState:UIControlStateNormal];
        [orderBtn addTarget:self action:@selector(orderSaleCar) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:orderBtn];
        
        YLCondition *consult = [YLCondition buttonWithType:UIButtonTypeCustom];
        consult.frame = CGRectMake(LeftMargin, CGRectGetMaxY(orderBtn.frame) + LeftMargin, btnW, btnH);
        consult.type = YLConditionTypeWhite;
        [consult setTitle:@"免费咨询" forState:UIControlStateNormal];
        [consult addTarget:self action:@selector(freeConsultation) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:consult];
    }
    return self;
}


- (void)orderSaleCar {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderSaleInFooterView)]) {
        [self.delegate orderSaleInFooterView];
    }
}

- (void)freeConsultation {
    if (self.delegate && [self.delegate respondsToSelector:@selector(freeConsultationInFooterView)]) {
        [self.delegate freeConsultationInFooterView];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
}

@end
