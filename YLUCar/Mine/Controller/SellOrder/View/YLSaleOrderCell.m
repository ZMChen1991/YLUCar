//
//  YLSaleOrderCell.m
//  YLGoodCard
//
//  Created by lm on 2018/12/1.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLSaleOrderCell.h"

@interface YLSaleOrderCell ()

@property (nonatomic, strong) UIImageView *icon; // 图片
@property (nonatomic, strong) UILabel *title; // 名称
@property (nonatomic, strong) UILabel *course; // 年/万公里
@property (nonatomic, strong) UILabel *price; // 销售价格
@property (nonatomic, strong) UILabel *originalPrice; // 新车价
@property (nonatomic, strong) UILabel *lookCarTime; // 看车时间

@property (nonatomic, strong) UIView *line;// 底线
@end

@implementation YLSaleOrderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"YLSaleOrderCell";
    YLSaleOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YLSaleOrderCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    icon.contentMode = UIViewContentModeScaleAspectFill;
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
    originalPrice.textAlignment = NSTextAlignmentLeft;
    originalPrice.textColor = YLColor(155.f, 155.f, 155.f);
    [self addSubview:originalPrice];
    self.originalPrice = originalPrice;
    
    UILabel *price = [[UILabel alloc] init];
    price.textColor = [UIColor redColor];
    price.font = [UIFont systemFontOfSize:18];
    [self addSubview:price];
    self.price = price;
    
//    UILabel *lookCarTime = [[UILabel alloc] init];
//    lookCarTime.text = @"看车时间:11月11日 17:50";
//    lookCarTime.font = [UIFont systemFontOfSize:12];
//    lookCarTime.textColor = [UIColor grayColor];
//    [self addSubview:lookCarTime];
//    self.lookCarTime = lookCarTime;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line];
    self.line = line;
}

- (void)setSaleOrderCellFrame:(YLSaleOrderCellFrame *)saleOrderCellFrame {
    _saleOrderCellFrame = saleOrderCellFrame;
    
    self.icon.frame = saleOrderCellFrame.iconF;
    self.title.frame = saleOrderCellFrame.titleF;
    self.price.frame = saleOrderCellFrame.priceF;
    self.course.frame = saleOrderCellFrame.courseF;
    self.originalPrice.frame = saleOrderCellFrame.originalPriceF;
    self.line.frame = saleOrderCellFrame.lineF;

    //  赋值
    [self.icon sd_setImageWithURL:[NSURL URLWithString:saleOrderCellFrame.model.detail.displayImg] placeholderImage:[UIImage imageNamed:@"优卡二手车"]];
    self.title.text = saleOrderCellFrame.model.detail.title;
    self.price.text = [NSString stringWithFormat:@"%@", [saleOrderCellFrame.model.detail.price stringToNumberString]];;
    self.course.text = [NSString stringWithFormat:@"%@万公里/年", saleOrderCellFrame.model.detail.course];
    NSString *str = [NSString stringWithFormat:@"新车价:%@", [saleOrderCellFrame.model.detail.originalPrice stringToNumberString]];
    NSDictionary *attri = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str attributes:attri];
    self.self.originalPrice.attributedText = attriStr;
}

@end
