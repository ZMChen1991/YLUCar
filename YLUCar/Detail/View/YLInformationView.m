//
//  YLInformationView.m
//  YLUCar
//
//  Created by lm on 2019/2/15.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLInformationView.h"

@interface YLInformationView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation YLInformationView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = YLColor(233.f, 233.f, 233.f).CGColor;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = YLFont(12);
        titleLabel.textColor = YLColor(155.f, 155.f, 155.f);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *detailLabel = [[UILabel alloc] init];
//        detailLabel.backgroundColor = [UIColor yellowColor];
        detailLabel.font = YLFont(12);
        detailLabel.textColor = YLColor(51.f, 51.f, 51.f);
        detailLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:detailLabel];
        self.detailLabel = detailLabel;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat labelX = 5;
    CGFloat labelW = self.frame.size.width * 0.5 - labelX;
    CGFloat labelH = self.frame.size.height;
    
    self.titleLabel.frame = CGRectMake(labelX, 0, labelW, labelH);
    self.detailLabel.frame = CGRectMake(labelW + labelX, 0, labelW, labelH);
}


- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setDetailTitle:(NSString *)detailTitle {
    _detailTitle = detailTitle;
    self.detailLabel.text = detailTitle;
}

@end
