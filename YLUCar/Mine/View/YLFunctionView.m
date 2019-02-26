//
//  YLFunctionView.m
//  YLUCar
//
//  Created by lm on 2019/2/13.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLFunctionView.h"
#import "YLNumberView.h"
#import "YLCustomButton.h"

@interface YLFunctionView ()

@property (nonatomic, strong) NSMutableArray *function;
@property (nonatomic, strong) NSMutableArray *orderFunction;
@property (nonatomic, strong) UILabel *line;

@end

@implementation YLFunctionView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    NSArray *arr = @[@"即将看车", @"我的收藏", @"浏览记录", @"我的订阅"];
    NSArray *arr1 = @[@"买车订单", @"卖车订单", @"砍价记录", @"降价提醒"];
    NSArray *images = @[@"买车订单", @"卖车订单", @"砍价记录", @"降价提醒"];
    
    for (NSInteger i = 0; i < arr.count; i++) {
        YLNumberView *numberView = [[YLNumberView alloc] init];
        numberView.number = @"0";
        numberView.title = arr[i];
        numberView.tag = 200 + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(numberViewClick:)];
        [numberView addGestureRecognizer:tap];
        [self addSubview:numberView];
        [self.function addObject:numberView];
    }
    
    for (NSInteger i = 0; i < arr1.count; i++) {
        YLCustomButton *btn = [YLCustomButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:arr1[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateHighlighted];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.orderFunction addObject:btn];
    }
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line];
    self.line = line;
}

- (void)numberViewClick:(UITapGestureRecognizer *)sender {
    YLNumberView *numberView = (YLNumberView *)sender.view;
    NSInteger index = numberView.tag - 200;
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberViewClickAtIndex:)]) {
        [self.delegate numberViewClickAtIndex:index];
    }
}

- (void)btnClick:(YLCustomButton *)sender {
    NSInteger index = sender.tag - 100;
    if (self.delegate && [self.delegate respondsToSelector:@selector(customBtnClickAtIndex:)]) {
        [self.delegate customBtnClickAtIndex:index];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width / 4;
    CGFloat height = self.frame.size.height / 2;
    NSInteger count = self.function.count;
    for (NSInteger i = 0; i < count; i++) {
        YLNumberView *numberView = self.function[i];
        numberView.frame = CGRectMake(width * i, 0, width, height);
        [numberView setFrame:CGRectIntegral(numberView.frame)];
    }
    
    NSInteger count1 = self.orderFunction.count;
    for (NSInteger i = 0; i < count1; i++) {
        YLCustomButton *custom = self.orderFunction[i];
        custom.frame = CGRectMake(width * i, height, width, height);
        [custom setFrame:CGRectIntegral(custom.frame)];
    }
    self.line.frame = CGRectMake(0, height * 2 - 1, YLScreenWidth, 1);
}

#pragma mark getter/setter
- (NSMutableArray *)function {
    if (!_function) {
        _function = [NSMutableArray array];
    }
    return _function;
}

- (NSMutableArray *)orderFunction {
    if (!_orderFunction) {
        _orderFunction = [NSMutableArray array];
    }
    return _orderFunction;
}

- (void)setNumbers:(NSArray *)numbers {
    _numbers = numbers;
    if (!numbers) {
        return;
    }
    
    NSInteger count = self.function.count;
    for (NSInteger i = 0; i < count; i++) {
        YLNumberView *numberView = self.function[i];
        numberView.number = numbers[i];
    }
}

- (void)setDepreciateNumber:(NSString *)depreciateNumber {
    _depreciateNumber = depreciateNumber;
    YLCustomButton *depreciateBtn = self.orderFunction[3];
    depreciateBtn.numbers = depreciateNumber;
}

- (void)setBargainNumber:(NSString *)bargainNumber {
    _bargainNumber = bargainNumber;
    YLCustomButton *bargainBtn = self.orderFunction[2];
    bargainBtn.numbers = bargainNumber;
}

@end
