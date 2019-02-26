//
//  YLCommandView.m
//  YLUCar
//
//  Created by lm on 2019/2/20.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLCommandView.h"
#import "YLCommandViewFrame.h"
#import "YLCommandModel.h"

@interface YLCommandView ()

@property (nonatomic, strong) UIImageView *icon; // 图片
@property (nonatomic, strong) UILabel *title; // 名称
@property (nonatomic, strong) UILabel *course; // 年/万公里
@property (nonatomic, strong) UILabel *price; // 销售价格
@property (nonatomic, strong) UILabel *originalPrice; // 新车价
@property (nonatomic, strong) UILabel *line;

@end

@implementation YLCommandView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tap];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
//    if (self.commandViewBlock) {
//        self.commandViewBlock();
//    }
    NSLog(@"tap");

    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCommandView)]) {
        [self.delegate clickCommandView];
    }
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
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line];
    self.line = line;
}

- (void)setViewFrame:(YLCommandViewFrame *)viewFrame {
    _viewFrame = viewFrame;
    self.icon.frame = viewFrame.iconF;
    self.title.frame = viewFrame.titleF;
    self.course.frame = viewFrame.courseF;
    self.price.frame = viewFrame.priceF;
    self.originalPrice.frame = viewFrame.originalPriceF;
    self.line.frame = viewFrame.lineF;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:viewFrame.model.displayImg] placeholderImage:[UIImage imageNamed:@"优卡二手车"]];
    self.title.text = viewFrame.model.title;
    NSString *year;
    if (viewFrame.model.licenseTime.length < 4) {
        year = @"";
    } else {
        year = [viewFrame.model.licenseTime substringToIndex:4];
    }
    NSString *course = [NSString stringWithFormat:@"%@年 / %@万公里", year,viewFrame.model.course];
    self.course.text = course;
    self.price.text = [viewFrame.model.price stringToNumberString];
    NSString *originalPrice =[viewFrame.model.originalPrice stringToNumberString];
    NSString *str = [NSString stringWithFormat:@"新车价%@", originalPrice];
    NSDictionary *attri = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str attributes:attri];
    self.self.originalPrice.attributedText = attriStr;
    
}

@end
