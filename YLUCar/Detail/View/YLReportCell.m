//
//  YLReportCell.m
//  YLUCar
//
//  Created by lm on 2019/2/15.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLReportCell.h"
#import "YLCondition.h"
#import "YLSubDetailModel.h"

@interface YLReportCell ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) YLCondition *consultBtn;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *pic;
@property (nonatomic, strong) UILabel *message;
@property (nonatomic, strong) UILabel *line;

@property (nonatomic, strong) UIView *bgView;

@end

@implementation YLReportCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YLReportCell";
    YLReportCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YLReportCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.contentMode = UIViewContentModeScaleToFill;
    icon.image = [UIImage imageNamed:@"评估师"];
    [self addSubview:icon];
    self.icon = icon;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"高级车辆评估师";
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    YLCondition *consult = [[YLCondition alloc] init];
    consult.type = YLConditionTypeBlue;
    consult.titleLabel.font = [UIFont systemFontOfSize:14];
    [consult setTitle:@"咨询车况" forState:UIControlStateNormal];
    [consult addTarget:self action:@selector(consultClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:consult];
    self.consultBtn = consult;
    
//    UITextView *detailLabel = [[UITextView alloc] init];
//    detailLabel.font = YLFont(14);
//    detailLabel.editable = NO;
//    detailLabel.bounces = NO;
//    detailLabel.contentInset = UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
//    detailLabel.backgroundColor = YLColor(233.f, 233.f, 233.f);
//    [self addSubview:detailLabel];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:bgView];
    self.bgView = bgView;
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.textColor = YLColor(155.f, 155.f, 155.f);
    detailLabel.numberOfLines = 0;
    detailLabel.font = YLFont(14);
    detailLabel.backgroundColor = [UIColor clearColor];
    [bgView addSubview:detailLabel];
    self.detailLabel = detailLabel;
    
    UIImageView *pic = [[UIImageView alloc] init];
    pic.image = [UIImage imageNamed:@"检测.jpg"];
    [self addSubview:pic];
    self.pic = pic;
    
    UILabel *message = [[UILabel alloc] init];
    message.font = YLFont(14);
    message.text = @"注:交易前陪同买卖双方进行67项复检";
    message.textColor = YLColor(155.f, 155.f, 155.f);
    [self addSubview:message];
    self.message = message;
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line];
    self.line = line;
}

- (void)consultClick {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(reportCellConsult)]) {
        [self.delegate reportCellConsult];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat iconW = 40;
    CGFloat margin = 5;
    self.icon.frame = CGRectMake(LeftMargin, margin, iconW, iconW);
    
    CGSize size = [self.titleLabel.text getSizeWithFont:YLFont(14)];
    CGFloat labelH = 40;
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.icon.frame) + margin, margin, size.width, labelH);
    
    CGFloat btnW = 80;
    CGFloat btnH = 30;
    self.consultBtn.frame = CGRectMake(self.frame.size.width - LeftMargin - btnW, 10, btnW, btnH);
    
    CGFloat detailW = self.frame.size.width - 2 * LeftMargin;
//    CGSize detailSize = [self.detailLabel.text getSizeWithFont:YLFont(14)];
    self.bgView.frame = CGRectMake(LeftMargin, CGRectGetMaxY(self.icon.frame) + TopMargin, detailW, 180);
    self.detailLabel.frame = CGRectMake(TopMargin, TopMargin, CGRectGetWidth(self.bgView.frame) - 2 * TopMargin, CGRectGetHeight(self.bgView.frame) - 2 * TopMargin);
    
    CGFloat picH = 159;
    self.pic.frame = CGRectMake(LeftMargin, CGRectGetMaxY(self.bgView.frame) + LeftMargin, detailW, picH);
    
    CGFloat messageH = 40;
    self.message.frame = CGRectMake(LeftMargin, CGRectGetMaxY(self.pic.frame), detailW, messageH);
    
    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.message.frame), self.frame.size.width, 1);
//    NSLog(@"%f", CGRectGetMaxY(self.line.frame));
}

- (void)setModel:(YLSubDetailModel *)model {
    _model = model;
    if (!model.descript) {
        return;
    }
    self.detailLabel.text = model.descript;
}
@end
