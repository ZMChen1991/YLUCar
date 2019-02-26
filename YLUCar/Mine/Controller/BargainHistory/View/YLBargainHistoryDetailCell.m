//
//  YLBargainHistoryDetailCell.m
//  YLGoodCard
//
//  Created by lm on 2018/12/3.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLBargainHistoryDetailCell.h"
#import "YLCondition.h"

@interface YLBargainHistoryDetailCell ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) YLCondition *dickerBtn;
@property (nonatomic, strong) YLCondition *acceptBtn;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UILabel *time;

@end

@implementation YLBargainHistoryDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID =@"YLBargainHistoryDetailCell";
    YLBargainHistoryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YLBargainHistoryDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    
    YLCondition *dicker = [YLCondition buttonWithType:UIButtonTypeCustom];
    dicker.type = YLConditionTypeWhite;
    dicker.titleLabel.font = [UIFont systemFontOfSize:14];
    [dicker setTitle:@"还价" forState:UIControlStateNormal];
    [dicker addTarget:self action:@selector(dicker) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dicker];
    self.dickerBtn = dicker;
    
    YLCondition *accept = [YLCondition buttonWithType:UIButtonTypeCustom];
    accept.type = YLConditionTypeBlue;
    accept.titleLabel.font = [UIFont systemFontOfSize:14];
    [accept setTitle:@"接受" forState:UIControlStateNormal];
    [accept addTarget:self action:@selector(accept) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:accept];
    self.acceptBtn = accept;
    
    UILabel *title = [[UILabel alloc] init];
    title.numberOfLines = 0;
    title.font = [UIFont systemFontOfSize:12];
    [self addSubview:title];
    self.title = title;
    
    UILabel *time = [[UILabel alloc] init];
    time.font = [UIFont systemFontOfSize:14];
    time.textColor = YLColor(190.f, 190.f, 190.f);
    [self addSubview:time];
    self.time = time;
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line];
    self.line = line;
}

- (void)setCellFrame:(YLBargainDetailCellFrame *)cellFrame {
    
    _cellFrame = cellFrame;
    
    self.title.frame = cellFrame.titleF;
    self.dickerBtn.frame = cellFrame.dickerF;
    self.acceptBtn.frame = cellFrame.acceptF;
    self.line.frame = cellFrame.lineF;
    self.time.frame = cellFrame.timeF;

    self.time.text = cellFrame.model.createAt;
    if (cellFrame.model.isBuyer) { //买家
        if ([cellFrame.model.mark isEqualToString:@"1"]) {// Mark=1
            if ([cellFrame.model.status isEqualToString:@"1"]) {
                self.title.text = [NSString stringWithFormat:@"卖家%@正在处理您的报价：%@,请耐心等候",[self cutOutTelephone:cellFrame.model.seller], [cellFrame.model.price stringToNumberString]];
            } else if ([cellFrame.model.status isEqualToString:@"2"]) {
                self.title.text = [NSString stringWithFormat:@"卖家%@已接受您的报价：%@,请等待客服联系",[self cutOutTelephone:cellFrame.model.seller], [cellFrame.model.price stringToNumberString]];
            } else {
                self.title.text = [NSString stringWithFormat:@"您的报价：%@", [cellFrame.model.price stringToNumberString]];
            }
        } else {// Mark=2
            if ([cellFrame.model.status isEqualToString:@"1"]) {
                self.title.text = [NSString stringWithFormat:@"卖家%@还价：%@，等待您的处理",[self cutOutTelephone:cellFrame.model.seller], [cellFrame.model.price stringToNumberString]];
            } else if ([cellFrame.model.status isEqualToString:@"2"]) {
                self.title.text = [NSString stringWithFormat:@"您已接受卖家%@的报价:%@,请等待客服联系",[self cutOutTelephone:cellFrame.model.seller], [cellFrame.model.price stringToNumberString]];
            } else {
                self.title.text = [NSString stringWithFormat:@"卖家%@还价:%@",[self cutOutTelephone:cellFrame.model.seller], [cellFrame.model.price stringToNumberString]];
            }
        }
    } else {// 卖家
        if ([cellFrame.model.mark isEqualToString:@"1"]) {// Mark=1
            if ([cellFrame.model.status isEqualToString:@"1"]) {
                self.title.text = [NSString stringWithFormat:@"您未处理买家%@的报价：%@",[self cutOutTelephone:cellFrame.model.buyer], [cellFrame.model.price stringToNumberString]];
            } else if ([cellFrame.model.status isEqualToString:@"2"]) {
                self.title.text = [NSString stringWithFormat:@"您已接受买家%@的报价：%@,等待客服联系",[self cutOutTelephone:cellFrame.model.buyer], [cellFrame.model.price stringToNumberString]];
            } else {
                self.title.text = [NSString stringWithFormat:@"买家%@报价：%@",[self cutOutTelephone:cellFrame.model.buyer], [cellFrame.model.price stringToNumberString]];
            }
        } else {// Mark=2
            if ([cellFrame.model.status isEqualToString:@"1"]) {
                self.title.text = [NSString stringWithFormat:@"您的还价：%@，等待买家%@的处理", [cellFrame.model.price stringToNumberString], [self cutOutTelephone:cellFrame.model.buyer]];
            } else if ([cellFrame.model.status isEqualToString:@"2"]) {
                self.title.text = [NSString stringWithFormat:@"买家%@已接受您的报价：%@,请等待客服联系", [self cutOutTelephone:cellFrame.model.buyer], [cellFrame.model.price stringToNumberString]];
            } else {
                self.title.text = [NSString stringWithFormat:@"您给买家%@的还价：%@", [self cutOutTelephone:cellFrame.model.buyer], [cellFrame.model.price stringToNumberString]];
            }
        }
    }
}

// 字符串转换：将电话号码部分转换成星字符
- (NSString *)replaceString:(NSString *)string {
    if (string.length < 9) {
        return @"";
    }
    NSString *str = [string substringWithRange:NSMakeRange(3, 6)];
    NSString *replaceString = [string stringByReplacingOccurrencesOfString:str withString:@"******"];
    return replaceString;
}

- (NSString *)cutOutTelephone:(NSString *)telephone {
    if (telephone.length < 7) {
        return @"";
    }
    NSString *str = [telephone substringFromIndex:7];
    return str;
}

- (void)accept {
//    if (self.accepBlock) {
//        self.accepBlock();
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(accepBargainPrice:)]) {
        [self.delegate accepBargainPrice:self.cellFrame.model];
    }
}

- (void)dicker {
//    if (self.dickerBlock) {
//        self.dickerBlock();
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dickBargainPrice:)]) {
        [self.delegate dickBargainPrice:self.cellFrame.model];
    }
}
@end
