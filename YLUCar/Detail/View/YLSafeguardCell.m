//
//  YLSafeguardCell.m
//  YLUCar
//
//  Created by lm on 2019/2/15.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLSafeguardCell.h"
#import "YLCustomButton.h"

@interface YLSafeguardCell ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation YLSafeguardCell

+ (instancetype)cellWithTable:(UITableView *)tableView {
    
    static NSString *ID = @"YLSafeguardCell";
    YLSafeguardCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YLSafeguardCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titles = @[@"1年2万公里保障", @"购车后30天内发现质量问题，可全额退款", @"更专业、更全面的检测服务，质量更有保障", @"买卖双方均只收取2%服务费，再无其他费用"];
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    
    NSArray *array = @[@"售后保障", @"30天可退", @"专业检测", @"服务费低"];
    NSArray *images = @[@"售后保障", @"30天可退", @"专业检测", @"服务费低"];
    for (NSInteger i = 0; i < array.count; i++) {
        YLCustomButton *btn = [[YLCustomButton alloc] init];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        // 图片显大，需修改
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.btns addObject:btn];
    }
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.titles[0];
    titleLabel.textColor = YLColor(33.f, 33.f, 33.f);
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line];
    self.line = line;
}

- (void)btnClick:(YLCustomButton *)sender {
    
    NSInteger index = sender.tag - 100;
    self.titleLabel.text = self.titles[index];
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    NSInteger count = self.titles.count;
    CGFloat btnW = (YLScreenWidth - 2 * LeftMargin) / count;
    CGFloat btnH = 60;
    for (NSInteger i = 0; i < count; i++) {
        YLCustomButton *btn = self.btns[i];
        btn.frame = CGRectMake(i * btnW + LeftMargin, 0, btnW, btnH);
    }
    CGFloat labelW = YLScreenWidth - 2 * LeftMargin;
    CGFloat labelH = 60;
    self.titleLabel.frame = CGRectMake(LeftMargin, btnH, labelW, labelH);
    
    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + LeftMargin, YLScreenWidth, 1);
}

- (NSMutableArray *)btns {
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}
@end
