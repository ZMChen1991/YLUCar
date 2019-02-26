//
//  YLBrandItemView.m
//  YLUCar
//
//  Created by lm on 2019/1/29.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLBrandItemView.h"
#import "YLConditionParamModel.h"


@implementation YLBrandItemView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, 1)];
    line1.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line1];
    
    NSArray *titles = @[@"5万以下", @"5-10万", @"10-15万", @"15万以上", @"宾利", @"丰田",@"大众", @"本田", @"奥迪", @"日产", @"雪佛兰", @"现代"];
    CGFloat labelW = ceilf(YLScreenWidth / 4);
    CGFloat labelH = ceilf(100 / 3);
    for (NSInteger i = 0; i < titles.count; i++) {
        NSInteger row = i / 4;
        NSInteger line = i % 4;
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(labelW * line, labelH * row + 10, labelW, labelH);
        label.text = titles[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = YLFont(14);
        label.textColor = YLColor(51.f, 51.f, 51.f);
        label.tag = 100 + i;
        [label setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(brandItemClick:)];
        [label addGestureRecognizer:tap];
        [self addSubview:label];
    }
}

- (void)brandItemClick:(UITapGestureRecognizer *)sender {
    UILabel *label = (UILabel *)sender.view;
    NSInteger tag = label.tag - 100;
    NSString *param;
    
    if ([label.text isEqualToString:@"5万以下"]) {
        param = @"0fgf50000";
    } else if ([label.text isEqualToString:@"5-10万"]) {
        param = @"50000fgf100000";
    } else if ([label.text isEqualToString:@"10-15万"]) {
        param = @"100000fgf150000";
    } else if ([label.text isEqualToString:@"15万以上"]) {
        param = @"150000fgf99999999";
    } else {
        param = label.text;
    }
    
    YLConditionParamModel *model = [[YLConditionParamModel alloc] init];
    model.title = label.text;
    model.detailTitle = label.text;
    model.isSelect = YES;
    if (tag < 4) {
        model.key = @"price";
    } else {
        model.key = @"brand";
    }
    model.param = param;
    if (self.delegate && [self.delegate respondsToSelector:@selector(choiceBrand:)]) {
        [self.delegate choiceBrand:model];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
}

@end
