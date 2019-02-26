//
//  YLNoneView.m
//  YLGoodCard
//
//  Created by lm on 2018/11/19.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLNoneView.h"
#import "YLCondition.h"

@interface YLNoneView ()

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) YLCondition *goBtn;

@end

@implementation YLNoneView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.frame = CGRectMake(YLScreenWidth / 2 - 61, 64, 122, 122);
    icon.image = [UIImage imageNamed:@"暂无收藏"];
    [self addSubview:icon];
    self.icon = icon;
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, CGRectGetMaxY(icon.frame) + 10, YLScreenWidth, 22);
    title.text  = @"暂无收藏记录";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:16];
    title.textColor = YLColor(155.f, 155.f, 155.f);
    [self addSubview:title];
    self.titleL = title;
    
    YLCondition *go = [YLCondition buttonWithType:UIButtonTypeCustom];
    go.frame = CGRectMake(YLScreenWidth / 2 - 70, CGRectGetMaxY(title.frame) + 20, 141, 44);
    go.type = YLConditionTypeBlue;
    [go setTitle:@"看看其他车源" forState:UIControlStateNormal];
    go.titleLabel.font = [UIFont systemFontOfSize:14];
    [go addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:go];
    self.goBtn = go;
}

- (void)go {
    
//    NSLog(@"现在去逛逛");
    self.hidden = !self.hidden;
    // 需要在控制器里重新获取数据
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadData)]) {
        [self.delegate reloadData];
    }
}

- (void)hideBtn {
    self.goBtn.hidden = YES;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleL.text = title;
}

- (void)setImage:(NSString *)image {
    _image = image;
    self.icon.image = [UIImage imageNamed:image];
}

@end
