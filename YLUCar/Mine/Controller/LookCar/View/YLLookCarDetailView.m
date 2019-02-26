//
//  YLLookCarDetailView.m
//  YLUCar
//
//  Created by lm on 2019/2/22.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLLookCarDetailView.h"
#import "YLDetectCenterModel.h"

@interface YLLookCarDetailView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *telephoneLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end


@implementation YLLookCarDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = YLColor(233.f, 233.f, 233.f).CGColor;
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"预约信息";
    titleLabel.font = YLFont(18);
    titleLabel.textColor = YLColor(51.f, 51.f, 51.f);
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *centerLabel = [[UILabel alloc] init];
    centerLabel.font = YLFont(14);
    centerLabel.textColor = YLColor(51.f, 51.f, 51.f);
    [self addSubview:centerLabel];
    self.centerLabel = centerLabel;
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.font = YLFont(14);
    addressLabel.textColor = YLColor(51.f, 51.f, 51.f);
    [self addSubview:addressLabel];
    self.addressLabel = addressLabel;
    
    UILabel *telephoneLabel = [[UILabel alloc] init];
    telephoneLabel.font = YLFont(14);
    telephoneLabel.textColor = YLColor(51.f, 51.f, 51.f);
    [self addSubview:telephoneLabel];
    self.telephoneLabel = telephoneLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = YLFont(14);
    timeLabel.textColor = YLColor(51.f, 51.f, 51.f);
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat viewW = self.frame.size.width;
    CGFloat labelW = viewW - 2 * LeftMargin;
    CGFloat titleH = 30;
    self.titleLabel.frame = CGRectMake(LeftMargin, LeftMargin, labelW, titleH);
    
    CGFloat labelH = 22;
    self.centerLabel.frame = CGRectMake(LeftMargin, CGRectGetMaxY(self.titleLabel.frame) + LeftMargin, labelW, labelH);
    self.addressLabel.frame = CGRectMake(LeftMargin, CGRectGetMaxY(self.centerLabel.frame) + Margin, labelW, labelH);
    self.telephoneLabel.frame = CGRectMake(LeftMargin, CGRectGetMaxY(self.addressLabel.frame) + Margin, labelW, labelH);
    self.timeLabel.frame = CGRectMake(LeftMargin, CGRectGetMaxY(self.telephoneLabel.frame) + Margin, labelW, labelH);
    NSLog(@"%f", CGRectGetMaxY(self.timeLabel.frame));
}

- (void)setModel:(YLDetectCenterModel *)model {
    _model = model;
    
    NSString *address = [NSString stringWithFormat:@"地址: %@", model.address];
    CGSize size = [address getSizeWithFont:YLFont(14)];
    CGFloat labelW = self.frame.size.width - 2 * LeftMargin;
    CGFloat labelH = 22;
    if (size.width > labelW) {
        labelH += 22;
    }
    self.addressLabel.frame = CGRectMake(LeftMargin, CGRectGetMaxY(self.centerLabel.frame) + Margin, labelW, labelH);
    
    self.addressLabel.text = address;
    self.centerLabel.text = [NSString stringWithFormat:@"检测中心: %@", model.name];
    self.telephoneLabel.text = [NSString stringWithFormat:@"联系电话: %@", model.phone];
}

- (void)setAppointTime:(NSString *)appointTime {
    _appointTime = appointTime;
    self.timeLabel.text = [NSString stringWithFormat:@"预约时间: %@", appointTime];
}

@end
