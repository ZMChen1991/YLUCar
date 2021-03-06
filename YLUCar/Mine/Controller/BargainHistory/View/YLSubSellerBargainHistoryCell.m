//
//  YLSubSellerBargainHistoryCell.m
//  YLGoodCard
//
//  Created by lm on 2018/12/13.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLSubSellerBargainHistoryCell.h"
#import "YLCondition.h"

@interface YLSubSellerBargainHistoryCell ()

@property (nonatomic, strong) UIImageView *icon; // 图片
@property (nonatomic, strong) UILabel *title; // 名称
@property (nonatomic, strong) UILabel *course; // 年/万公里
@property (nonatomic, strong) UILabel *price; // 销售价格
@property (nonatomic, strong) UILabel *originalPrice; // 新车价
@property (nonatomic, strong) YLCondition *bargainNumber;// 砍价数量
@property (nonatomic, strong) UILabel *message;
@property (nonatomic, strong) UIImageView *soldOut;// 下架

@property (nonatomic, strong) UIView *line;

@end

@implementation YLSubSellerBargainHistoryCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"YLBargainHistoryCell";
    YLSubSellerBargainHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YLSubSellerBargainHistoryCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.backgroundColor = YLColor(233.f, 233.f, 233.f);
    icon.layer.cornerRadius = 5.f;
    icon.layer.masksToBounds = YES;
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
    originalPrice.textColor = YLColor(155.f, 155.f, 155.f);
    originalPrice.textAlignment = NSTextAlignmentLeft;
    [self addSubview:originalPrice];
    self.originalPrice = originalPrice;
    
    UILabel *price = [[UILabel alloc] init];
    price.textColor = [UIColor redColor];
    price.font = [UIFont systemFontOfSize:18];
    [self addSubview:price];
    self.price = price;
    
    UILabel *message = [[UILabel alloc] init];
    message.textColor = YLColor(155.f, 155.f, 155.f);
    message.font = [UIFont systemFontOfSize:12];
    //    message.backgroundColor = [UIColor redColor];
    [self addSubview:message];
    self.message = message;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line];
    self.line = line;
    
    YLCondition *bargainNumber = [YLCondition buttonWithType:UIButtonTypeCustom];
    bargainNumber.type = YLConditionTypeWhite;
//    [bargainNumber setTitle:@"10" forState:UIControlStateNormal];
    bargainNumber.hidden = YES;
    bargainNumber.layer.cornerRadius = 18.f;
    bargainNumber.layer.masksToBounds = YES;
    [self addSubview:bargainNumber];
    self.bargainNumber = bargainNumber;
    
    // 当车辆状态是下架的时候，显示该图片，位置与砍价数量一致
    UIImageView *soldOut = [[UIImageView alloc] init];
    soldOut.backgroundColor = [UIColor clearColor];
    soldOut.hidden = YES;
    [self addSubview:soldOut];
    self.soldOut = soldOut;
}

- (void)setCellFrame:(YLBargainHistoryCellFrame *)cellFrame {
    _cellFrame = cellFrame;
    
    self.icon.frame = cellFrame.iconF;
    self.title.frame = cellFrame.titleF;
    self.price.frame = cellFrame.priceF;
    self.course.frame = cellFrame.courseF;
    self.originalPrice.frame = cellFrame.originalPriceF;
    self.message.frame = cellFrame.messageF;
    self.bargainNumber.frame = cellFrame.bargainNumberF;
    self.soldOut.frame = cellFrame.soldOutF;
    self.line.frame = cellFrame.lineF;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:cellFrame.model.detail.displayImg] placeholderImage:nil];
    self.title.text = cellFrame.model.detail.title;
    self.price.text = [self stringToNumber:cellFrame.model.detail.price];
    self.course.text = [NSString stringWithFormat:@"%@万公里/年", cellFrame.model.detail.course];
    NSString *str = [NSString stringWithFormat:@"新车价%@", [self stringToNumber:cellFrame.model.detail.originalPrice]];
    NSDictionary *attri = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str attributes:attri];
    self.self.originalPrice.attributedText = attriStr;
//    self.originalPrice.text = [NSString stringWithFormat:@"新车价%@", [self stringToNumber:cellFrame.model.detail.originalPrice]];
    
    if ([cellFrame.model.detail.status isEqualToString:@"4"]) { // 车辆下架
        self.soldOut.hidden = NO;
        self.soldOut.image = [UIImage imageNamed:@"已售"];
        self.bargainNumber.hidden = YES;
    } else if ([cellFrame.model.detail.status isEqualToString:@"0"]) { // 车辆取消
        self.soldOut.hidden = NO;
        self.soldOut.image = [UIImage imageNamed:@"已下架"];
        self.bargainNumber.hidden = YES;
    } else if ([cellFrame.model.detail.status isEqualToString:@"5"]) { // 车辆已签合同
        self.soldOut.hidden = NO;
        self.soldOut.image = [UIImage imageNamed:@"已售"];
        self.bargainNumber.hidden = YES;
    } else if ([cellFrame.model.detail.status isEqualToString:@"6"]) { // 车辆复检
        self.soldOut.hidden = NO;
        self.bargainNumber.hidden = YES;
    } else { // 车辆处于在售状态
        if ([cellFrame.model.count isEqualToString:@"0"]) {
            self.bargainNumber.hidden = YES;
            self.soldOut.hidden = YES;
        } else {
            self.soldOut.hidden = YES;
            self.bargainNumber.hidden = NO;
            [self.bargainNumber setTitle:cellFrame.model.count forState:UIControlStateNormal];
        }
    }   
}


- (NSString *)stringToNumber:(NSString *)number {
    
    float count = [number floatValue] / 10000;
    return [NSString stringWithFormat:@"%.2f万",count];
}
@end
