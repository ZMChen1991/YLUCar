//
//  YLCommandCellView.m
//  YLUCar
//
//  Created by lm on 2019/1/28.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLCommandCellView.h"

@interface YLCommandCellView ()

@property (nonatomic, strong) UIImageView *icon; // 图片
@property (nonatomic, strong) UILabel *title; // 名称
@property (nonatomic, strong) UILabel *course; // 年/万公里
@property (nonatomic, strong) UILabel *price; // 销售价格
@property (nonatomic, strong) UILabel *originalPrice; // 新车价
@property (nonatomic, strong) UIImageView *downIcon;// 向下箭头
@property (nonatomic, strong) UILabel *downTitle;// 降价信息
@property (nonatomic, strong) UIButton *bargain;// 砍价数量

@property (nonatomic, strong) UIView *line;// 底线

@end

@implementation YLCommandCellView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.backgroundColor = YLColor(233.f, 233.f, 233.f);
    icon.layer.cornerRadius = 5.f;
    icon.layer.masksToBounds = YES;
    icon.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:icon];
    self.icon = icon;
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:14];
    title.numberOfLines = 0;
    [self addSubview:title];
    self.title = title;
    
    UILabel *course = [[UILabel alloc] init];
    course.textColor = [UIColor blackColor];
    course.font = [UIFont systemFontOfSize:12];
    course.textAlignment = NSTextAlignmentLeft;
    [self addSubview:course];
    self.course = course;
    
    UILabel *originalPrice = [[UILabel alloc] init];
    originalPrice.font = [UIFont systemFontOfSize:12];
    originalPrice.textAlignment = NSTextAlignmentLeft;
    originalPrice.textColor = YLColor(155.f, 155.f, 155.f);
    [self addSubview:originalPrice];
    self.originalPrice = originalPrice;
    
    UILabel *price = [[UILabel alloc] init];
    price.textColor = [UIColor redColor];
    price.font = [UIFont systemFontOfSize:18];
    [self addSubview:price];
    self.price = price;
    
    UIImageView *downIcon = [[UIImageView alloc] init];
    downIcon.backgroundColor = [UIColor blueColor];
    [self addSubview:downIcon];
    self.downIcon = downIcon;
    
    UILabel *downTitle = [[UILabel alloc] init];
    downTitle.textColor = [UIColor redColor];
    downTitle.font = [UIFont systemFontOfSize:12];
    downTitle.textColor = [UIColor grayColor];
    downTitle.backgroundColor = [UIColor yellowColor];
    [self addSubview:downTitle];
    self.downTitle = downTitle;
    
    UIButton *bargain = [UIButton buttonWithType:UIButtonTypeCustom];
    bargain.layer.cornerRadius = 18;
    bargain.layer.masksToBounds = YES;
    bargain.backgroundColor = [UIColor greenColor];
    [self addSubview:bargain];
    self.bargain = bargain;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line];
    self.line = line;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
}
@end
