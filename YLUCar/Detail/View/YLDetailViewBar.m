//
//  YLDetailViewBar.m
//  YLUCar
//
//  Created by lm on 2019/2/16.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLDetailViewBar.h"
#import "YLCondition.h"
#import "YLDetailModel.h"

@interface YLDetailViewBar ()

@property (nonatomic, strong) UIButton *collectBtn;// 收藏
@property (nonatomic, strong) UIButton *consultBtn;// 客服
@property (nonatomic, strong) YLCondition *bargain;// 砍价
@property (nonatomic, strong) YLCondition *orderCar;// 预约看车
@property (nonatomic, strong) UILabel *line;

@end

@implementation YLDetailViewBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line];
    self.line = line;
    
    UIButton *consultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [consultBtn setImage:[UIImage imageNamed:@"客服"] forState:UIControlStateNormal];
    [consultBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [consultBtn addTarget:self action:@selector(consultClick) forControlEvents:UIControlEventTouchUpInside];
//    consultBtn.backgroundColor = [UIColor redColor];
    [self addSubview:consultBtn];
    self.consultBtn = consultBtn;
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
    [collectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(collectClick) forControlEvents:UIControlEventTouchUpInside];
//    collectBtn.backgroundColor = [UIColor redColor];
    [self addSubview:collectBtn];
    self.collectBtn = collectBtn;
    
    YLCondition *bargain = [YLCondition buttonWithType:UIButtonTypeCustom];
    bargain.type = YLConditionTypeWhite;
    bargain.titleLabel.font = [UIFont systemFontOfSize:14];
    [bargain setTitle:@"砍价" forState:UIControlStateNormal];
    [bargain addTarget:self action:@selector(bargainClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bargain];
    self.bargain = bargain;
    
    YLCondition *orderCar = [YLCondition buttonWithType:UIButtonTypeCustom];
    orderCar.type = YLConditionTypeBlue;
    orderCar.titleLabel.font = [UIFont systemFontOfSize:14];
    [orderCar setTitle:@"预约看车" forState:UIControlStateNormal];
    [orderCar addTarget:self action:@selector(orderCarClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:orderCar];
    self.orderCar = orderCar;
}

- (void)consultClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(consultCustom)]) {
        [self.delegate consultCustom];
    }
}

- (void)collectClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectCar)]) {
        [self.delegate collectCar];
    }
}

- (void)bargainClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bargainPrice)]) {
        [self.delegate bargainPrice];
    }
}

- (void)orderCarClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderLookCar)]) {
        [self.delegate orderLookCar];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat height = self.frame.size.height - 2 * TopMargin;
    CGFloat consultW = 30;
    CGFloat viewY = TopMargin;
    
    self.consultBtn.frame = CGRectMake(LeftMargin, viewY, consultW, height);
    
    CGFloat collectW = 35;
    self.collectBtn.frame = CGRectMake(CGRectGetMaxX(self.consultBtn.frame) + TopMargin, viewY, collectW, height);
    
    CGFloat btnX = CGRectGetMaxX(self.collectBtn.frame) + TopMargin;
    CGFloat btnW = (self.frame.size.width - btnX - LeftMargin - TopMargin) / 2;
    self.bargain.frame = CGRectMake(btnX, viewY, btnW, height);
    self.orderCar.frame = CGRectMake(CGRectGetMaxX(self.bargain.frame) + TopMargin, viewY, btnW, height);
    self.line.frame = CGRectMake(0, 0, YLScreenWidth, 1);
    
}

- (void)setModel:(YLDetailModel *)model {
    _model = model;
    
    if ([model.isBook isEqualToString:@"1"]) {
        [self.orderCar setTitle:@"已预约" forState:UIControlStateNormal];
        self.orderCar.userInteractionEnabled = NO;
    } else {
        [self.orderCar setTitle:@"预约看车" forState:UIControlStateNormal];
        self.orderCar.userInteractionEnabled = YES;
    }
    
    if ([model.isCollect isEqualToString:@"1"]) {
        [self.collectBtn setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateNormal];
    } else {
        [self.collectBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
    }
}

@end
