//
//  YLMineHeaderView.m
//  YLUCar
//
//  Created by lm on 2019/2/13.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLMineHeaderView.h"

@interface YLMineHeaderView ()

@property (nonatomic, strong) UIImageView *icon;// 头像
@property (nonatomic, strong) UIButton *loginBtn;// 登录按钮
@property (nonatomic, strong) UILabel *detailTitle;// 登录详情
@property (nonatomic, strong) UILabel *name;// 登录账号



@end

@implementation YLMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UIImageView *icon = [[UIImageView alloc] init];
//    icon.backgroundColor = [UIColor redColor];
    icon.contentMode = UIViewContentModeScaleToFill;
    icon.image = [UIImage imageNamed:@"评估师"];
    [self addSubview:icon];
    self.icon = icon;
    
    UILabel *name = [[UILabel alloc] init];
    name.font = [UIFont systemFontOfSize:16];
    name.textColor = [UIColor whiteColor];
    name.textAlignment = NSTextAlignmentLeft;
//    name.backgroundColor = [UIColor greenColor];
    [self addSubview:name];
    self.name = name;
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = [UIColor clearColor];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
//    loginBtn.backgroundColor = [UIColor grayColor];
    [self addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    UILabel *detailTitle = [[UILabel alloc] init];
    detailTitle.font = [UIFont systemFontOfSize:14];
    detailTitle.textAlignment = NSTextAlignmentLeft;
    detailTitle.text = @"登录后可查看更多车辆信息";
    detailTitle.textColor = [UIColor whiteColor];
//    detailTitle.backgroundColor = [UIColor blueColor];
    [self addSubview:detailTitle];
    self.detailTitle = detailTitle;
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundImageView.image = [self graphicsImageWithSize:self.bounds.size];
    [self insertSubview:backgroundImageView atIndex:0];
    
}

// 返回一个渐变色图片
- (UIImage *)graphicsImageWithSize:(CGSize)size {
    CGGradientRef gradient;// 颜色的空间
    size_t num_locations = 2;// 渐变中使用的颜色数
    CGFloat locations[] = {0.0, 1.0}; // 指定每个颜色在渐变色中的位置，值介于0.0-1.0之间, 0.0表示最开始的位置，1.0表示渐变结束的位置
    CGFloat colors[] = {
        13.0/255.0, 196.f/255.f, 255.f/255, 1.0,
        3.0/255.0, 141.f/255.f, 255.f/255, 1.0,
    }; // 指定渐变的开始颜色，终止颜色，以及过度色（如果有的话）
    gradient = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(), colors, locations, num_locations);
    CGPoint startPoint = CGPointMake(0.0, 0.0);
    CGPoint endPoint = CGPointMake(self.frame.size.width, 1.0);
    //    CGSize size = CGSizeMake(self.view.frame.size.width, 1.0);
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    NSLog(@"%f-%f", image.size.width, image.size.height);
    return image;
}

- (void)login {
    // 跳转登录控制器
    if (self.delegate && [self.delegate respondsToSelector:@selector(skipLoginController)]) {
        [self.delegate skipLoginController];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.icon.frame = CGRectMake(LeftMargin, LeftMargin, 60, 60);
    self.name.frame = CGRectMake(CGRectGetMaxX(self.icon.frame) + LeftMargin, 30, 200, 25);
    self.loginBtn.frame = CGRectMake(CGRectGetMaxX(self.icon.frame) + LeftMargin, 22, 75, 25);
    self.detailTitle.frame = CGRectMake(CGRectGetMaxX(self.icon.frame) + LeftMargin, CGRectGetMaxY(self.loginBtn.frame) + 5, 200, 20);
}

- (void)setTelephone:(NSString *)telephone {
    _telephone = telephone;
    self.name.text = telephone;
}

- (void)setType:(YLMineHeaderViewType)type {
    _type = type;
    if (type == YLMineHeaderViewTypeLogout) {
        self.name.hidden = YES;
        self.loginBtn.hidden = NO;
        self.detailTitle.hidden = NO;
    } else {
        self.name.hidden = NO;
        self.loginBtn.hidden = YES;
        self.detailTitle.hidden = YES;
        
    }
}

@end
