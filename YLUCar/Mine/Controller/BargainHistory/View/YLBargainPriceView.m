//
//  YLBargainPriceView.m
//  YLUCar
//
//  Created by lm on 2019/2/21.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLBargainPriceView.h"
#import "YLCondition.h"

@interface YLBargainPriceView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *bargainPrice;
@property (nonatomic, strong) YLCondition *cancelBtn;
@property (nonatomic, strong) YLCondition *sureBtn;


@end

@implementation YLBargainPriceView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"请输入您期望的价格(单位:万)";
    titleLabel.font = YLFont(14);
    titleLabel.textColor = YLColor(51.f, 51.f, 51.f);
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UITextField *bargainPrice = [[UITextField alloc] init];
    bargainPrice.layer.borderWidth = 1.f;
    bargainPrice.layer.borderColor = YLColor(233.f, 233.f, 233.f).CGColor;
    bargainPrice.keyboardType = UIKeyboardTypeDecimalPad;
    bargainPrice.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    bargainPrice.leftViewMode = UITextFieldViewModeAlways;
    [self addSubview:bargainPrice];
    self.bargainPrice = bargainPrice;
    
    YLCondition *cancelBtn = [YLCondition buttonWithType:UIButtonTypeCustom];
    cancelBtn.type = YLConditionTypeWhite;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = YLFont(14);
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    
    YLCondition *sureBtn = [YLCondition buttonWithType:UIButtonTypeCustom];
    sureBtn.type = YLConditionTypeBlue;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = YLFont(14);
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
    self.sureBtn = sureBtn;
}

- (void)cancelClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelBargainPrice)]) {
        [self.delegate cancelBargainPrice];
    }
}

- (void)sureClick {
    if (self.bargainPrice.text.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sureBargainPrice:)]) {
            [self.delegate sureBargainPrice:self.bargainPrice.text];
        }
    } else {
        [NSString showMessage:@"请输入价格"];
    }
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat viewW = self.frame.size.width;
    self.titleLabel.frame = CGRectMake(LeftMargin, LeftMargin, viewW - 2 * LeftMargin, 20);
    self.bargainPrice.frame = CGRectMake(LeftMargin, CGRectGetMaxY(self.titleLabel.frame) + LeftMargin, viewW - 2 *LeftMargin, 40);
    CGFloat btnW = (viewW - 3 * LeftMargin) / 2;
    CGFloat btnH = 40;
    self.cancelBtn.frame = CGRectMake(LeftMargin, CGRectGetMaxY(self.bargainPrice.frame) + LeftMargin, btnW, btnH);
    self.sureBtn.frame = CGRectMake(CGRectGetMaxX(self.cancelBtn.frame) + LeftMargin, CGRectGetMaxY(self.bargainPrice.frame) + LeftMargin, btnW, btnH);
}

@end
