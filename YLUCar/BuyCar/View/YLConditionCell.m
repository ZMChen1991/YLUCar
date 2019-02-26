//
//  YLConditionCell.m
//  HomeCollectionView
//
//  Created by lm on 2018/11/10.
//  Copyright © 2018 CocaCola. All rights reserved.
//


#import "YLConditionCell.h"

@interface YLConditionCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation YLConditionCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ceilf(self.bounds.size.width), self.bounds.size.height)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = YLColor(233.f, 233.f, 233.f);
        [self addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)change {
    NSLog(@"change");
    self.label.backgroundColor = [UIColor whiteColor];
    self.label.textColor = YLColor(8.f, 169.f, 255.f);
    self.label.layer.borderColor = YLColor(8.f, 169.f, 255.f).CGColor;
    self.label.layer.borderWidth = 1.f;
}

- (void)rest {
    NSLog(@"rest");
    self.label.backgroundColor = YLColor(233.f, 233.f, 233.f);
    self.label.textColor = [UIColor blackColor];
    self.label.layer.borderColor = YLColor(233.f, 233.f, 233.f).CGColor;
    self.label.layer.borderWidth = 1.f;
}

- (void)setModel:(YLConditionParamModel *)model {
    _model = model;
    if (model.isSelect) {
        self.label.backgroundColor = [UIColor whiteColor];
        self.label.textColor = YLColor(8.f, 169.f, 255.f);
        self.label.layer.borderColor = YLColor(8.f, 169.f, 255.f).CGColor;
        self.label.layer.borderWidth = 1.f;
    } else {
        self.label.backgroundColor = YLColor(247.f, 247.f, 247.f);
        self.label.textColor = YLColor(51.f, 51.f, 51.f);
        self.label.layer.borderColor = YLColor(247.f, 247.f, 247.f).CGColor;
        self.label.layer.borderWidth = 1.f;
    }
    self.label.text = model.title;
}

@end
