//
//  YLCarInformationView.m
//  YLUCar
//
//  Created by lm on 2019/2/16.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLCarInformationView.h"
@interface YLCarInformationView ()

@property (nonatomic, strong) UIImageView *carImage;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YLCarInformationView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UIImageView *carImage = [[UIImageView alloc] init];
    carImage.contentMode = UIViewContentModeScaleAspectFill;
//    carImage.contentMode = UIViewContentModeScaleToFill;
    carImage.layer.cornerRadius = 5.f;
    carImage.layer.masksToBounds = YES;
    carImage.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:carImage];
    self.carImage = carImage;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = YLFont(14);
    titleLabel.textColor = YLColor(155.f, 155.f, 155.f);
//    titleLabel.backgroundColor = [UIColor redColor];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat labelH = 20;
    CGFloat margin = 5;
    CGFloat carImageW = self.frame.size.width;
    CGFloat carImageH = self.frame.size.height - labelH;
    self.carImage.frame = CGRectMake(0, 0, carImageW, carImageH);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.carImage.frame) + margin, carImageW, labelH);
}

- (void)setImage:(NSString *)image {
    _image = image;
    [self.carImage sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"优卡二手车"]];
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}
@end
