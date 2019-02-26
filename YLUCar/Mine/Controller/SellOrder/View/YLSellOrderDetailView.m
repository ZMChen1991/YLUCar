//
//  YLSellOrderDetailView.m
//  YLUCar
//
//  Created by lm on 2019/2/20.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLSellOrderDetailView.h"
#import "YLCommandView.h"
#import "YLCondition.h"
#import "YLStepView.h"
#import "YLLookCarNumberView.h"
#import "YLSaleOrderModel.h"
#import "YLSaleOrderDetailModel.h"
#import "YLCommandViewFrame.h"
#import "YLCommandModel.h"


@interface YLSellOrderDetailView ()

@property (nonatomic, strong) YLCommandView *commandView;
@property (nonatomic, strong) YLCondition *changePrice;
@property (nonatomic, strong) YLCondition *soldOut;
@property (nonatomic, strong) YLCondition *putaway;
@property (nonatomic, strong) YLStepView *stepView;
@property (nonatomic, strong) YLLookCarNumberView *lookCarNumberView;

@end

@implementation YLSellOrderDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

- (void)setupUI {
    
    YLCommandView *commandView = [[YLCommandView alloc] init];
    commandView.backgroundColor = [UIColor whiteColor];
    commandView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [commandView addGestureRecognizer:tap];
    [self addSubview:commandView];
    self.commandView = commandView;
    
    YLCondition *changePrice = [YLCondition buttonWithType:UIButtonTypeCustom];
    changePrice.type = YLConditionTypeWhite;
    changePrice.titleLabel.font = YLFont(14);
    [changePrice setTitle:@"修改价格" forState:UIControlStateNormal];
    [changePrice addTarget:self action:@selector(changePriceClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:changePrice];
    self.changePrice = changePrice;
    
    YLCondition *soldOut = [YLCondition buttonWithType:UIButtonTypeCustom];
    soldOut.type = YLConditionTypeBlue;
    soldOut.titleLabel.font = YLFont(14);
    [soldOut setTitle:@"车辆下架" forState:UIControlStateNormal];
    [soldOut addTarget:self action:@selector(soldOutClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:soldOut];
    self.soldOut = soldOut;
    
    YLCondition *putaway = [YLCondition buttonWithType:UIButtonTypeCustom];
    putaway.type = YLConditionTypeBlue;
    putaway.titleLabel.font = YLFont(14);
    [putaway setTitle:@"重新上架" forState:UIControlStateNormal];
    [putaway addTarget:self action:@selector(putawayClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:putaway];
    self.putaway = putaway;
    
    NSArray *titles = @[@"待检测", @"售卖中", @"已签合同", @"已完成"];// 根据订单状态而定
    YLStepView *stepView = [[YLStepView alloc] initWithFrame:CGRectZero titles:titles];
    [self addSubview:stepView];
    self.stepView = stepView;
    
    YLLookCarNumberView *lookCarNumberView = [[YLLookCarNumberView alloc] init];
    [self addSubview:lookCarNumberView];
    self.lookCarNumberView = lookCarNumberView;
}

- (void)tap:(UITapGestureRecognizer *)sender {
    NSLog(@"clickCommandView");
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkCarDetail)]) {
        [self.delegate checkCarDetail];
    }
}

- (void)changePriceClick {
    NSLog(@"修改价格");
    if (self.delegate && [self.delegate respondsToSelector:@selector(sellOrderDetailChangePrice)]) {
        [self.delegate sellOrderDetailChangePrice];
    }
}

- (void)soldOutClick {
    NSLog(@"车辆下架");
    if (self.delegate && [self.delegate respondsToSelector:@selector(sellOrderDetailSoldOut)]) {
        [self.delegate sellOrderDetailSoldOut];
    }
}

- (void)putawayClick {
    NSLog(@"车辆上架");
    if (self.delegate && [self.delegate respondsToSelector:@selector(sellOrderDetailPutaway)]) {
        [self.delegate sellOrderDetailPutaway];
    }
}

- (void)setModel:(YLSaleOrderModel *)model {
    
    _model = model;
    YLCommandModel *commandModel = [YLCommandModel mj_objectWithKeyValues:model.detail];
    YLCommandViewFrame *viewFrame = [[YLCommandViewFrame alloc] init];
    viewFrame.model = commandModel;
    self.commandView.viewFrame = viewFrame;
    self.commandView.frame = CGRectMake(0, 0, YLScreenWidth, viewFrame.viewHeight);
    
    // 下架
    CGFloat btnW = (YLScreenWidth - 3 * LeftMargin) / 2;
    CGFloat btnH = 40;
    CGFloat btnY = viewFrame.viewHeight + LeftMargin;
    CGFloat stepViewW = YLScreenWidth - 2 * LeftMargin;
    CGFloat stepViewH = 100.f;
    CGFloat putawayW = YLScreenWidth - 2 * LeftMargin;
    CGFloat lookCarNumberH = 30;
    CGFloat lookCarNumberW = YLScreenWidth;
    if ([model.detail.status isEqualToString:@"0"]) { // 取消状态，显示上架按钮
        self.changePrice.frame = CGRectZero;
        self.soldOut.frame = CGRectZero;
        self.putaway.frame = CGRectMake(LeftMargin, btnY, putawayW, btnH);
        self.stepView.frame = CGRectMake(LeftMargin, CGRectGetMaxY(self.putaway.frame) + LeftMargin, stepViewW, stepViewH);
        self.lookCarNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.stepView.frame), lookCarNumberW, lookCarNumberH);
        
    } else if ([model.detail.status isEqualToString:@"1"]) {// 待提交
        self.changePrice.frame = CGRectZero;
        self.soldOut.frame = CGRectZero;
        self.putaway.frame = CGRectZero;
        self.stepView.frame = CGRectMake(LeftMargin, btnY, stepViewW, stepViewH);
        self.lookCarNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.stepView.frame), lookCarNumberW, lookCarNumberH);
        
    } else if ([model.detail.status isEqualToString:@"2"]) {// 待审核
        self.changePrice.frame = CGRectZero;
        self.soldOut.frame = CGRectZero;
        self.putaway.frame = CGRectZero;
        self.stepView.frame = CGRectMake(LeftMargin, btnY, stepViewW, stepViewH);
        self.lookCarNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.stepView.frame), lookCarNumberW, lookCarNumberH);
        self.stepView.stepIndex = 0;
        
    } else if ([model.detail.status isEqualToString:@"3"]) {// 上架
        self.putaway.frame = CGRectZero;
        self.changePrice.frame = CGRectMake(LeftMargin, btnY, btnW, btnH);
        self.soldOut.frame = CGRectMake(CGRectGetMaxX(self.changePrice.frame) + LeftMargin, btnY, btnW, btnH);
        self.stepView.frame = CGRectMake(LeftMargin, CGRectGetMaxY(self.changePrice.frame) + LeftMargin, stepViewW, stepViewH);
        self.lookCarNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.stepView.frame), lookCarNumberW, lookCarNumberH);
        self.stepView.stepIndex = 1;
        
    } else if ([model.detail.status isEqualToString:@"4"]) {// 下架
        self.changePrice.frame = CGRectZero;
        self.soldOut.frame = CGRectZero;
//        self.putaway.frame = CGRectMake(LeftMargin, btnY, putawayW, btnH);
        self.putaway.frame = CGRectZero;
        self.stepView.frame = CGRectMake(LeftMargin, btnY + LeftMargin, stepViewW, stepViewH);
        self.lookCarNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.stepView.frame), lookCarNumberW, lookCarNumberH);
        self.stepView.stepIndex = 3;
        
    } else if ([model.detail.status isEqualToString:@"5"]) {// 合同签署
        self.changePrice.frame = CGRectZero;
        self.soldOut.frame = CGRectZero;
        self.putaway.frame = CGRectZero;
        self.stepView.frame = CGRectMake(LeftMargin, btnY, stepViewW, stepViewH);
        self.lookCarNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.stepView.frame), lookCarNumberW, lookCarNumberH);
        self.stepView.stepIndex = 2;
        
    } else if ([model.detail.status isEqualToString:@"6"]) {// 车辆复检
        self.changePrice.frame = CGRectZero;
        self.soldOut.frame = CGRectZero;
        self.putaway.frame = CGRectZero;
        self.stepView.frame = CGRectMake(LeftMargin, btnY, stepViewW, stepViewH);
        self.lookCarNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.stepView.frame) + LeftMargin, lookCarNumberW, lookCarNumberH);
        self.stepView.stepIndex = 3;
    }
    
    self.lookCarNumberView.tureNumber = model.detail.lookSum;
    self.lookCarNumberView.browseNumber = model.detail.clickSum;
}



@end
