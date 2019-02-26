//
//  YLTableGroupHeader.m
//  YLGoodCard
//
//  Created by lm on 2018/11/15.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLTableGroupHeader.h"

@interface YLTableGroupHeader ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailTitleLabel;
@property (nonatomic, strong) UIImageView *arrowIcon;
@property (nonatomic, strong) UIView *view;
//@property (nonatomic, strong) UIView *line;

@end

@implementation YLTableGroupHeader

- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)image title:(NSString *)title detailTitle:(NSString *)detailTitle arrowImage:(NSString *)arrowImage {
    
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *icon = [[UIImageView alloc] init];
        icon.contentMode = UIViewContentModeScaleAspectFit;
        icon.image = [UIImage imageNamed:image];
        [self addSubview:icon];
        self.icon = icon;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = [UIColor redColor];
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
        [view addGestureRecognizer:tap];
        [self addSubview:view];
        self.view = view;
        
        UILabel *detailTitleLabel = [[UILabel alloc] init];
        detailTitleLabel.text = detailTitle;
        detailTitleLabel.textColor = YLColor(155.f, 155.f, 155.f);
        detailTitleLabel.textAlignment = NSTextAlignmentRight;
        detailTitleLabel.font = [UIFont systemFontOfSize:12];
        detailTitleLabel.userInteractionEnabled = YES;
        [view addSubview:detailTitleLabel];
        self.detailTitleLabel = detailTitleLabel;
        
        UIImageView *arrowIcon = [[UIImageView alloc] init];
        arrowIcon.image = [UIImage imageNamed:arrowImage];
        [view addSubview:arrowIcon];
        self.arrowIcon = arrowIcon;
        
    }
    return self;
}

- (void)labelClick:(UITapGestureRecognizer *)tap {

    if (self.delegate && [self.delegate respondsToSelector:@selector(pushBuyControl)]) {
        [self.delegate pushBuyControl];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushMoreControl)]) {
        [self.delegate pushMoreControl];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat iconH = height - 2 * TopMargin;
    CGFloat titleW = width / 3;
    self.icon.frame = CGRectMake(LeftMargin, TopMargin, 20, iconH);
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.icon.frame) + 5, TopMargin, titleW, iconH);
    CGSize size = [self.detailTitleLabel.text getSizeWithFont:YLFont(12)];
    CGFloat viewW = size.width + 12;
    self.view.frame = CGRectMake(width - TopMargin - viewW, TopMargin , viewW, iconH);
    
    self.detailTitleLabel.frame = CGRectMake(0, 0, size.width, iconH);
    self.arrowIcon.frame = CGRectMake(CGRectGetMaxX(self.detailTitleLabel.frame) + 5, 5, 7, iconH/2);
}

@end
