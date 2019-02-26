//
//  YLCollectHeader.m
//  HomeCollectionView
//
//  Created by lm on 2018/11/10.
//  Copyright © 2018 CocaCola. All rights reserved.
//
// RGB颜色
#define YLColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 随机色
#define YLRandomColor YLColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#import "YLCollectHeader.h"
#import "NSString+Extension.h"

@interface YLCollectHeader ()

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *detailL;

@end

@implementation YLCollectHeader

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
}

- (void)setupUI {
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"排量(单位:万公里)";
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = YLColor(51.0, 51.0, 51.0);
    title.textAlignment = NSTextAlignmentLeft;
    [self addSubview:title];
    self.titleL = title;
    
    UILabel *detailTitle = [[UILabel alloc] init];
    detailTitle.text = @"更多";
    detailTitle.font = [UIFont systemFontOfSize:12];
    detailTitle.textColor = YLColor(155.0, 155.0, 155.0);
    detailTitle.textAlignment = NSTextAlignmentLeft;
    [self addSubview:detailTitle];
    self.detailL = detailTitle;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self setupUI];
    CGSize size = [title getSizeWithFont:[UIFont systemFontOfSize:14]];
    CGRect rect = CGRectMake(15, 0, size.width + 10, 30);
    self.titleL.frame = rect;
    self.titleL.text = title;
}

- (void)setDetailTitle:(NSString *)detailTitle {
    _detailTitle = detailTitle;
    CGSize size = [detailTitle getSizeWithFont:[UIFont systemFontOfSize:14]];
    CGRect rect = CGRectMake(CGRectGetMaxX(self.titleL.frame) + 10, 0, size.width + 10, 20);
    self.titleL.frame = rect;
    self.detailL.text = detailTitle;
}

@end
