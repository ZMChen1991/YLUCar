//
//  YLSaleOrderChangePriceView.m
//  YLUCar
//
//  Created by lm on 2019/2/22.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLSaleOrderChangePriceView.h"
#import "YLCondition.h"

@interface YLSaleOrderChangePriceView ()

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *floorPrice;
@property (nonatomic, strong) UITextField *priceTextField;
@property (nonatomic, strong) UITextField *floorPriceTextField;
@property (nonatomic, strong) UIView *acceptView;
@property (nonatomic, strong) UILabel *accept;
@property (nonatomic, strong) UILabel *acceptLabel;
@property (nonatomic, strong) UIView *refuseView;
@property (nonatomic, strong) UILabel *refuse;
@property (nonatomic, strong) UILabel *refuseLabel;
@property (nonatomic, strong) YLCondition *sureBtn;
@property (nonatomic, strong) YLCondition *cancelBtn;

@property (nonatomic, assign) BOOL isAccept;

@end

@implementation YLSaleOrderChangePriceView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        self.isAccept = YES;
    }
    return self;
}

- (void)setupUI {
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.text = @"修改卖车价格(单位:万)";
    priceLabel.font = YLFont(14);
    priceLabel.textColor = YLColor(51.f, 51.f, 51.f);
    priceLabel.textAlignment = NSTextAlignmentLeft;
//    priceLabel.backgroundColor = [UIColor redColor];
    [self addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    UILabel *floorPrice = [[UILabel alloc] init];
    floorPrice.text = @"修改卖车底价(单位:万)";
    floorPrice.font = YLFont(14);
    floorPrice.textColor = YLColor(51.f, 51.f, 51.f);
    floorPrice.textAlignment = NSTextAlignmentLeft;
//    floorPrice.backgroundColor = [UIColor redColor];
    [self addSubview:floorPrice];
    self.floorPrice = floorPrice;
    
    UITextField *priceTextField = [[UITextField alloc] init];
    priceTextField.font = YLFont(14);
    priceTextField.textAlignment = NSTextAlignmentRight;
    priceTextField.layer.borderColor = YLColor(233.f, 233.f, 233.f).CGColor;
    priceTextField.layer.borderWidth = 1.f;
    priceTextField.rightViewMode = UITextFieldViewModeAlways;
    [self addSubview:priceTextField];
    self.priceTextField = priceTextField;
    
    UITextField *floorPriceTextField = [[UITextField alloc] init];
    floorPriceTextField.textAlignment = NSTextAlignmentRight;
    floorPriceTextField.font = YLFont(14);
    floorPriceTextField.layer.borderColor = YLColor(233.f, 233.f, 233.f).CGColor;
    floorPriceTextField.layer.borderWidth = 1.f;
    floorPriceTextField.rightViewMode = UITextFieldViewModeAlways;
    [self addSubview:floorPriceTextField];
    self.floorPriceTextField = floorPriceTextField;
    
    UIView *acceptView = [[UIView alloc] init];
    UITapGestureRecognizer *acceptTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(acceptClick)];
    [acceptView addGestureRecognizer:acceptTap];
    [self addSubview:acceptView];
    self.acceptView = acceptView;
    
    UILabel *accept = [[UILabel alloc] init];
    accept.layer.cornerRadius = 10.f;
    accept.layer.masksToBounds = YES;
    accept.layer.borderWidth = 1.f;
    accept.layer.borderColor = YLColor(233.f, 233.f, 233.f).CGColor;
    accept.backgroundColor = YLColor(8.f, 169.f, 255.f);
    [acceptView addSubview:accept];
    self.accept = accept;
    
    UILabel *acceptLabel = [[UILabel alloc] init];
    acceptLabel.textColor = YLColor(51.f, 51.f, 51.f);
    acceptLabel.text = @"接受议价";
    acceptLabel.font = YLFont(14);
    [acceptView addSubview:acceptLabel];
    self.acceptLabel = acceptLabel;
    
    UIView *refuseView = [[UIView alloc] init];
    UITapGestureRecognizer *refuseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refuseClick)];
    [refuseView addGestureRecognizer:refuseTap];
    [self addSubview:refuseView];
    self.refuseView = refuseView;
    
    UILabel *refuse = [[UILabel alloc] init];
    refuse.layer.cornerRadius = 10.f;
    refuse.layer.masksToBounds = YES;
    refuse.layer.borderWidth = 1.f;
    refuse.layer.borderColor = YLColor(233.f, 233.f, 233.f).CGColor;
    refuse.backgroundColor = [UIColor whiteColor];
    [refuseView addSubview:refuse];
    self.refuse = refuse;
    
    UILabel *refuseLabel = [[UILabel alloc] init];
    refuseLabel.textColor = YLColor(51.f, 51.f, 51.f);
    refuseLabel.text = @"不接受议价";
    refuseLabel.font = YLFont(14);
    [refuseView addSubview:refuseLabel];
    self.refuseLabel = refuseLabel;
 
    YLCondition *cancelBtn = [YLCondition buttonWithType:UIButtonTypeCustom];
    cancelBtn.type = YLConditionTypeWhite;
    cancelBtn.titleLabel.font = YLFont(14);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    
    YLCondition *sureBtn = [YLCondition buttonWithType:UIButtonTypeCustom];
    sureBtn.type = YLConditionTypeBlue;
    sureBtn.titleLabel.font = YLFont(14);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
    self.sureBtn = sureBtn;
}

- (void)sureClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sureWithPrice:floorPrice:isAccept:)]) {
        [self.delegate sureWithPrice:self.priceTextField.text floorPrice:self.floorPriceTextField.text isAccept:self.isAccept];
    }
}

- (void)cancelClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelChangePrice)]) {
        [self.delegate cancelChangePrice];
    }
}

- (void)acceptClick {
    
    self.isAccept = YES;
    self.accept.backgroundColor = YLColor(8.f, 169.f, 255.f);
    self.refuse.backgroundColor = [UIColor whiteColor];
}

- (void)refuseClick {
    self.isAccept = NO;
    self.accept.backgroundColor = [UIColor whiteColor];
    self.refuse.backgroundColor = YLColor(8.f, 169.f, 255.f);
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat priceLabelW = 150;
    CGFloat priceLabelH = 30;
    CGFloat priceLabelY = 2 * LeftMargin;
    self.priceLabel.frame = CGRectMake(LeftMargin, priceLabelY, priceLabelW, priceLabelH);
    
    CGFloat priceTextFieldW = self.frame.size.width - priceLabelW - 3 * LeftMargin;
    self.priceTextField.frame = CGRectMake(CGRectGetMaxX(self.priceLabel.frame) + LeftMargin, priceLabelY, priceTextFieldW, priceLabelH);
    self.priceTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TopMargin, priceLabelH)];
    
    CGFloat floorPriceY = CGRectGetMaxY(self.priceLabel.frame) + LeftMargin;
    self.floorPrice.frame = CGRectMake(LeftMargin, floorPriceY, priceLabelW, priceLabelH);
    self.floorPriceTextField.frame = CGRectMake(CGRectGetMaxX(self.floorPrice.frame) + LeftMargin, floorPriceY, priceTextFieldW, priceLabelH);
    self.floorPriceTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TopMargin, priceLabelH)];
    
    CGFloat acceptW = (self.frame.size.width - 3 *LeftMargin) / 2;
    CGFloat acceptH = 20;
    CGFloat acceptY = CGRectGetMaxY(self.floorPrice.frame) + LeftMargin;
    self.acceptView.frame = CGRectMake(LeftMargin, acceptY, acceptW, acceptH);
    self.accept.frame = CGRectMake(0, 0, acceptH, acceptH);
    self.acceptLabel.frame = CGRectMake(CGRectGetMaxX(self.accept.frame) + Margin, 0, acceptW - acceptH, acceptH);
    self.refuseView.frame = CGRectMake(CGRectGetMaxX(self.acceptView.frame) + LeftMargin, acceptY, acceptW, acceptH);
    self.refuse.frame = CGRectMake(0, 0, acceptH, acceptH);
    self.refuseLabel.frame = CGRectMake(CGRectGetMaxX(self.refuse.frame) + Margin, 0, acceptW - acceptH, acceptH);
    
    CGFloat btnW = (self.frame.size.width - 3 * LeftMargin) / 2;
    CGFloat btnH = 40;
    CGFloat btnY = CGRectGetMaxY(self.acceptView.frame) + LeftMargin;
    self.cancelBtn.frame = CGRectMake(LeftMargin, btnY, btnW, btnH);
    self.sureBtn.frame = CGRectMake(CGRectGetMaxX(self.cancelBtn.frame) + LeftMargin, btnY, btnW, btnH);
//    NSLog(@"sureBtn:%f", CGRectGetMaxY(self.sureBtn.frame) + LeftMargin);
//    NSLog(@"%@-%@-%@-%@", self.priceLabel.text, self.priceLabel, self.floorPrice.text, self.floorPrice);
}

@end
