//
//  YLDetailHeaderView.m
//  YLUCar
//
//  Created by lm on 2019/2/15.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLDetailHeaderView.h"
#import "YLBannerCollectionView.h"
#import "YLCondition.h"
#import "YLDetailBannerModel.h"
#import "YLDetailModel.h"
#import "YLSubDetailModel.h"

@interface YLDetailHeaderView () <SDCycleScrollViewDelegate, YLBannerCollectionViewDelegate>

@property (nonatomic, strong) YLBannerCollectionView *banner;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *originalPriceLabel;
@property (nonatomic, strong) UILabel *quotePriceLabel;
@property (nonatomic, strong) UIButton *remindBtn;
@property (nonatomic, strong) YLCondition *bargainBtn;
@property (nonatomic, strong) UILabel *line;

@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) YLSubDetailModel *subDetailModel;

@end

@implementation YLDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    YLBannerCollectionView *banner = [[YLBannerCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 220)];
    banner.backgroundColor = YLColor(233.f, 233.f, 233.f);
    banner.delegate = self;
    [self addSubview:banner];
    self.banner = banner;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = YLFont(16);
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.numberOfLines = 0;
//    titleLabel.backgroundColor = [UIColor redColor];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIView *tagView = [[UIView alloc] init];
//    tagView.backgroundColor = [UIColor redColor];
    [self addSubview:tagView];
    self.tagView = tagView;
    
    NSArray *titles = @[@"0过户", @"准新车"];
    for (NSInteger i = 0; i < titles.count; i++) {
        YLCondition *btn = [[YLCondition alloc] init];
        btn.type = YLConditionTypeWhite;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [tagView addSubview:btn];
        [self.btns addObject:btn];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"车主报价";
    label.font = YLFont(12);
    [self addSubview:label];
    self.label = label;
    
    UILabel *price = [[UILabel alloc] init];
    price.font = YLFont(26);
    price.textColor = [UIColor redColor];
    price.text = @"0.00万";
    [self addSubview:price];
    self.priceLabel = price;
    
    UILabel *originalPrice = [[UILabel alloc] init];
    originalPrice.font = YLFont(12);
    originalPrice.textColor = YLColor(155.f, 155.f, 155.f);
    NSString *originalPriceString = [NSString stringWithFormat:@"新车含税%@万", @"0.00"];
    NSDictionary *attri = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:originalPriceString attributes:attri];
    originalPrice.attributedText = attriStr;
    [self addSubview:originalPrice];
    self.originalPriceLabel = originalPrice;
    
    UIButton *remindBtn = [UIButton buttonWithType:UIButtonTypeCustom]; // 14 * 14
    [remindBtn setImage:[UIImage imageNamed:@"提醒"] forState:UIControlStateNormal];
    [remindBtn addTarget:self action:@selector(remind) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:remindBtn];
    self.remindBtn = remindBtn;
    
    YLCondition *bargain = [YLCondition buttonWithType:UIButtonTypeCustom];
    bargain.type = YLConditionTypeWhite;
    [bargain setTitle:@"砍价" forState:UIControlStateNormal];
    bargain.titleLabel.font = YLFont(14);
    [bargain addTarget:self action:@selector(bargainClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bargain];
    self.bargainBtn = bargain;
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line];
    self.line = line;
}

- (void)bargainClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bargain)]) {
        [self.delegate bargain];
    }
}

- (void)remind {
    if (self.delegate && [self.delegate respondsToSelector:@selector(priceRemind)]) {
        [self.delegate priceRemind];
    }
}

- (void)pushImageController:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickToPictureModelInIndex:)]) {
        [self.delegate clickToPictureModelInIndex:index];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.banner.frame = CGRectMake(0, 0, self.frame.size.width, 220);
    CGFloat titleW = self.frame.size.width - 2 * LeftMargin;
    CGFloat titleH = 44;
    CGFloat tagViewH = 22;
    self.titleLabel.frame = CGRectMake(LeftMargin, CGRectGetMaxY(self.banner.frame) + TopMargin, titleW, titleH);
    self.tagView.frame = CGRectMake(LeftMargin, CGRectGetMaxY(self.titleLabel.frame) + TopMargin, titleW, tagViewH);
    
    CGFloat btnX = 0;
    for (NSInteger i = 0; i < self.btns.count; i++) {
        YLCondition *btn = self.btns[i];
        CGSize size = [btn.titleLabel.text getSizeWithFont:YLFont(12)];
        btn.frame = CGRectMake(btnX, 0, size.width + TopMargin, tagViewH);
        btnX += size.width + 2 * TopMargin;
    }
    
    CGSize labelSize = [self.label.text getSizeWithFont:YLFont(12)];
    CGFloat labelY = CGRectGetMaxY(self.tagView.frame) + LeftMargin + 5;
    self.label.frame = CGRectMake(LeftMargin, labelY, labelSize.width, labelSize.height);
    
    CGSize priceSize = [self.priceLabel.text getSizeWithFont:YLFont(26)];
    self.priceLabel.frame = CGRectMake(CGRectGetMaxX(self.label.frame), CGRectGetMaxY(self.tagView.frame) + TopMargin, priceSize.width, priceSize.height);
    
    CGSize originalSize = [self.originalPriceLabel.text getSizeWithFont:YLFont(12)];
    self.originalPriceLabel.frame = CGRectMake(CGRectGetMaxX(self.priceLabel.frame) + 5, labelY, originalSize.width, originalSize.height);
    
    self.remindBtn.frame = CGRectMake(CGRectGetMaxX(self.originalPriceLabel.frame) + 5, labelY, originalSize.height, originalSize.height);
    
    CGFloat bargainW = 56;
    self.bargainBtn.frame = CGRectMake(self.frame.size.width - LeftMargin - bargainW, CGRectGetMaxY(self.tagView.frame) + TopMargin, bargainW, priceSize.height);
    
    self.line.frame = CGRectMake(0, ceilf(CGRectGetMaxY(self.priceLabel.frame)) + LeftMargin, self.frame.size.width, 1);

}


- (void)setDetail:(NSDictionary *)detail {
    _detail = detail;
    
    if (!detail) {
        return;
    }
    
//    YLDetailModel *detailModel = [YLDetailModel mj_objectWithKeyValues:detail[@"data"]];
    self.subDetailModel = [YLSubDetailModel mj_objectWithKeyValues:detail[@"data"][@"detail"]];
    NSArray *models = [YLDetailBannerModel mj_objectArrayWithKeyValuesArray:detail[@"data"][@"image"][@"vehicle"]];
    
    self.titleLabel.text = self.subDetailModel.title;
    NSString *price = [self.subDetailModel.price stringToNumberString];
    CGSize priceSize = [price getSizeWithFont:YLFont(26)];
    self.priceLabel.frame = CGRectMake(CGRectGetMaxX(self.label.frame), CGRectGetMaxY(self.tagView.frame) + TopMargin, priceSize.width, priceSize.height);
    self.priceLabel.text = price;
    
    NSString *originalPrice = [NSString stringWithFormat:@"新车含税%@", [self.subDetailModel.originalPrice stringToNumberString]];
    NSDictionary *attri = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:originalPrice attributes:attri];
    CGSize originalSize = [originalPrice getSizeWithFont:YLFont(12)];
    CGFloat labelY = CGRectGetMaxY(self.tagView.frame) + LeftMargin + 5;
    self.originalPriceLabel.frame = CGRectMake(CGRectGetMaxX(self.priceLabel.frame) + 5, labelY, originalSize.width, originalSize.height);
    self.originalPriceLabel.attributedText = attriStr;
    
    NSMutableArray *images = [NSMutableArray array];
    for (YLDetailBannerModel *model in models) {
        [images addObject:model.img];
    }
    self.banner.images = images;
    
    // 根据数据判断tagView是否隐藏
    YLCondition *btn = self.btns[0];
    YLCondition *btn1 = self.btns[1];
    if (self.subDetailModel.zeroTransfer) {
        btn.hidden = NO;
    } else {
        CGFloat btnW = [btn1.titleLabel.text getSizeWithFont:YLFont(12)].width + TopMargin;
        btn1.frame = CGRectMake(0, 0, btnW, CGRectGetHeight(self.tagView.frame));
        btn.hidden = YES;
    }
    
    if (self.subDetailModel.newCar) {
        btn1.hidden = NO;
    } else {
        btn1.hidden = YES;
    }
}


- (NSMutableArray *)btns {
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}
@end
