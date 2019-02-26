//
//  YLCollectionCarCell.m
//  YLUCar
//
//  Created by lm on 2019/2/19.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLCollectionCarCell.h"
#import "YLCollectCellFrame.h"
#import "YLCollectionDetailModel.h"
#import "YLCollectionModel.h"

@interface YLCollectionCarCell ()

@property (nonatomic, strong) UIImageView *icon; // 图片
@property (nonatomic, strong) UILabel *title; // 名称
@property (nonatomic, strong) UILabel *course; // 年/万公里
@property (nonatomic, strong) UILabel *price; // 销售价格
@property (nonatomic, strong) UILabel *originalPrice; // 新车价
@property (nonatomic, strong) UILabel *lookCarTime; // 看车时间
@property (nonatomic, strong) UIView *line;// 底线

@end

@implementation YLCollectionCarCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"YLSubCell";
    YLCollectionCarCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YLCollectionCarCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    icon.contentMode = UIViewContentModeScaleAspectFill;
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
    
    UILabel *lookCarTime = [[UILabel alloc] init];
    lookCarTime.text = @"看车时间:11月11日 17:50";
    lookCarTime.font = [UIFont systemFontOfSize:12];
    lookCarTime.textColor = [UIColor grayColor];
    [self addSubview:lookCarTime];
    self.lookCarTime = lookCarTime;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line];
    self.line = line;
}

- (void)setCellFrame:(YLCollectCellFrame *)cellFrame {
    self.icon.frame = cellFrame.iconF;
    self.title.frame = cellFrame.titleF;
    self.price.frame = cellFrame.priceF;
    self.originalPrice.frame = cellFrame.originalPriceF;
    self.course.frame = cellFrame.courseF;
    self.line.frame = cellFrame.lineF;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:cellFrame.model.detail.displayImg] placeholderImage:[UIImage imageNamed:@"优卡二手车"]];
    self.title.text = cellFrame.model.detail.title;
    self.price.text = [cellFrame.model.detail.price stringToNumberString];
    NSString *str = [NSString stringWithFormat:@"新车价:%@", [cellFrame.model.detail.originalPrice stringToNumberString]];
    NSDictionary *attri = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str attributes:attri];
    self.self.originalPrice.attributedText = attriStr;
    NSString *year;
    if (cellFrame.model.detail.licenseTime.length < 4) {
        year = @"";
    } else {
        year = [cellFrame.model.detail.licenseTime substringToIndex:4];
    }
    NSString *course = [NSString stringWithFormat:@"%@年 / %@万公里", year,cellFrame.model.detail.course];
    self.course.text = course;
}

@end
