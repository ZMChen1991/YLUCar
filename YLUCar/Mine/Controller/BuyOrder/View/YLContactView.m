//
//  YLContactView.m
//  YLUCar
//
//  Created by lm on 2019/2/21.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLContactView.h"
#import "YLStepView.h"
#import "YLCondition.h"

@interface YLContactView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) YLCondition *contactBtn;
@property (nonatomic, strong) YLStepView *stepView;

@end

@implementation YLContactView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = YLFont(20);
    titleLabel.textColor = YLColor(8.f, 169.f, 255.f);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.font = YLFont(12);
    detailLabel.textColor = YLColor(155.f, 155.f, 155.f);
    [self addSubview:detailLabel];
    self.detailLabel = detailLabel;
    
    NSArray *titles = @[@"合同签署", @"车辆复检", @"交易完成"];
    YLStepView *stepView = [[YLStepView alloc] initWithFrame:CGRectZero titles:titles];
    [self addSubview:stepView];
    self.stepView = stepView;
    
    YLCondition *contact = [YLCondition buttonWithType:UIButtonTypeCustom];
    contact.type = YLConditionTypeBlue;
    contact.titleLabel.font = YLFont(14);
    [contact setTitle:@"联系客服" forState:UIControlStateNormal];
    [contact addTarget:self action:@selector(contactClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:contact];
    self.contactBtn = contact;
}

- (void)contactClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(contactCustomer)]) {
        [self.delegate contactCustomer];
    }
}

- (void)setModel:(YLBuyOrderModel *)model {
    _model = model;
    
    CGFloat stepViewH = 100;
    CGFloat labelW = YLScreenWidth - 2 * LeftMargin;
    self.stepView.frame = CGRectMake(LeftMargin, LeftMargin, labelW, stepViewH);
    CGFloat titleLabelH = 28;
    self.titleLabel.frame = CGRectMake(LeftMargin, CGRectGetMaxY(self.stepView.frame) + LeftMargin, labelW, titleLabelH);
    CGFloat btnH = 40;
    self.contactBtn.frame = CGRectMake(LeftMargin, CGRectGetMaxY(self.titleLabel.frame) + LeftMargin, labelW, btnH);
    CGFloat detaiLabelH = 20;
    self.detailLabel.frame = CGRectMake(LeftMargin, CGRectGetMaxY(self.contactBtn.frame) + TopMargin, labelW, detaiLabelH);
    self.detailLabel.text = @"注:如您有任何疑问或者售后需求，请联系我们的客服";
    
    if ([model.status isEqualToString:@"3"]) { // 已签合同
        self.stepView.stepIndex = 0;
        self.titleLabel.text = @"车辆已签合同";
    } else if ([model.status isEqualToString:@"4"]) {// 复检过户
        self.stepView.stepIndex = 1;
        self.titleLabel.text = @"车辆已复检过户";
    } else if ([model.status isEqualToString:@"5"]) {// 交易完成
        self.stepView.stepIndex = 2;
        self.titleLabel.text = @"车辆已交易完成";
    } else if ([model.status isEqualToString:@"20"]) {// 交易取消
        self.titleLabel.text = @"交易已取消";
    }
    
}

@end
