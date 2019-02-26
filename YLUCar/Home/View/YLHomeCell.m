//
//  YLHomeCell.m
//  YLUCar
//
//  Created by lm on 2019/1/28.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLHomeCell.h"

@interface YLHomeCell ()

@property (nonatomic, strong) UIImageView *displayImg; // 图片
@property (nonatomic, strong) UILabel *title; // 名称
@property (nonatomic, strong) UILabel *course; // 年/万公里
@property (nonatomic, strong) UILabel *price; // 销售价格
@property (nonatomic, strong) UILabel *originalPrice; // 新车价
@property (nonatomic, strong) UIImageView *downIcon;// 向下箭头
@property (nonatomic, strong) UILabel *downTitle;// 降价信息
@property (nonatomic, strong) UIButton *bargain;// 砍价数量

@property (nonatomic, strong) UIView *line;// 底线

@end

@implementation YLHomeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"YLHomeCell";
    YLHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YLHomeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UIImageView *displayImg = [[UIImageView alloc] init];
    displayImg.backgroundColor = YLColor(233.f, 233.f, 233.f);
    displayImg.layer.cornerRadius = 5.f;
    displayImg.layer.masksToBounds = YES;
    displayImg.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:displayImg];
    self.displayImg = displayImg;
    
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
    
    UIImageView *downIcon = [[UIImageView alloc] init];
    downIcon.backgroundColor = [UIColor blueColor];
    [self addSubview:downIcon];
    self.downIcon = downIcon;
    
    UILabel *downTitle = [[UILabel alloc] init];
    downTitle.textColor = [UIColor redColor];
    downTitle.font = [UIFont systemFontOfSize:12];
    downTitle.textColor = [UIColor grayColor];
    downTitle.backgroundColor = [UIColor yellowColor];
    [self addSubview:downTitle];
    self.downTitle = downTitle;
    
    UIButton *bargain = [UIButton buttonWithType:UIButtonTypeCustom];
    bargain.layer.cornerRadius = 18;
    bargain.layer.masksToBounds = YES;
    bargain.backgroundColor = [UIColor greenColor];
    [self addSubview:bargain];
    self.bargain = bargain;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line];
    self.line = line;
}

- (void)setCellFrame:(YLCommandCellFrame *)cellFrame {
    _cellFrame = cellFrame;
    
    self.displayImg.frame = cellFrame.displayImgF;
    self.title.frame = cellFrame.titleF;
    self.course.frame = cellFrame.courseF;
    self.price.frame = cellFrame.priceF;
    self.originalPrice.frame = cellFrame.originalPriceF;
    self.line.frame = cellFrame.lineF;
    
    NSArray *titles = [cellFrame.model.displayImg componentsSeparatedByString:@"@w_"];
    NSString *imageUrl;
    if (cellFrame.isLargeImage) {
        imageUrl = [NSString stringWithFormat:@"%@@w_%@", [titles firstObject], @"1200"];
    } else {
        imageUrl = cellFrame.model.displayImg;
    }
    [self.displayImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"占位图"]];
    self.title.text = cellFrame.model.title;
    NSString *year;
    if (cellFrame.model.licenseTime.length < 4) {
        year = @"";
    } else {
        year = [cellFrame.model.licenseTime substringToIndex:4];
    }
//    NSString *courseString = [NSString stringWithFormat:@"%.f", [cellFrame.model.course floatValue]];
    NSString *course = [NSString stringWithFormat:@"%@年 / %@万公里", year,cellFrame.model.course];
    self.course.text = course;
    self.price.text = [cellFrame.model.price stringToNumberString];
    NSString *originalPrice =[cellFrame.model.originalPrice stringToNumberString];
    NSString *str = [NSString stringWithFormat:@"新车价%@", originalPrice];
    NSDictionary *attri = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str attributes:attri];
    self.self.originalPrice.attributedText = attriStr;
}

@end
