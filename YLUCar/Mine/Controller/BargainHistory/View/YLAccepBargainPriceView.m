//
//  YLAccepBargainPriceView.m
//  YLUCar
//
//  Created by lm on 2019/2/21.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLAccepBargainPriceView.h"
#import "YLCondition.h"

@interface YLAccepBargainPriceView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) YLCondition *cancelBtn;
@property (nonatomic, strong) YLCondition *sureBtn;

@end

@implementation YLAccepBargainPriceView

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
    titleLabel.text = @"确定接受买家价格";
    titleLabel.font = YLFont(16);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = YLColor(51.f, 51.f, 51.f);
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
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

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat viewW = self.frame.size.width;
    self.titleLabel.frame = CGRectMake(LeftMargin, LeftMargin, viewW - 2 * LeftMargin, 20);
    CGFloat btnW = (viewW - 3 * LeftMargin) / 2;
    CGFloat btnH = 40;
    self.cancelBtn.frame = CGRectMake(LeftMargin, CGRectGetMaxY(self.titleLabel.frame) + LeftMargin, btnW, btnH);
    self.sureBtn.frame = CGRectMake(CGRectGetMaxX(self.cancelBtn.frame) + LeftMargin, CGRectGetMaxY(self.titleLabel.frame) + LeftMargin, btnW, btnH);
}

- (void)cancelClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelAccept)]) {
        [self.delegate cancelAccept];
    }
}

- (void)sureClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sureAccept)]) {
        [self.delegate sureAccept];
    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(surePutaway)]) {
//        [self.delegate surePutaway];
//    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(sureSoldOut)]) {
//        [self.delegate sureSoldOut];
//    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

@end
