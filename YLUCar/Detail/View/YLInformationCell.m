//
//  YLInformationCell.m
//  YLUCar
//
//  Created by lm on 2019/2/15.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLInformationCell.h"
#import "YLInformationView.h"
#import "YLSubDetailModel.h"

@interface YLInformationCell ()

@property (nonatomic, strong) NSMutableArray *titleLabels;
@property (nonatomic, strong) NSMutableArray *detailLabels;


@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, strong) UILabel *line;

@end


@implementation YLInformationCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YLInformationCell";
    YLInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YLInformationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    NSArray *titles = @[@"表显里程(单位:万公里)", @"上牌时间", @"车牌所在地", @"看车地点", @"排放量(单位:L)", @"环保标准", @"变速箱", @"登记证为准", @"年检到期", @"商业险到期", @"交强险到期", @""];
//    NSArray *detaiTitles = @[@"表显里程", @"上牌时间", @"车牌所在地", @"看车地点", @"排放量", @"环保标准", @"变速箱", @"登记证为准", @"年检到期", @"商业险到期", @"交强险到期", @""];
    for (NSInteger i = 0; i < titles.count; i++) {
        YLInformationView *view = [[YLInformationView alloc] init];
        view.title = titles[i];
//        view.detailTitle = detaiTitles[i];
        [self addSubview:view];
        [self.views addObject:view];
    }
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line];
    self.line = line;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat viewW = (self.frame.size.width - 2 * LeftMargin) / 2;
    CGFloat viewH = 30;
    for (NSInteger i = 0; i < self.views.count; i++) {
        NSInteger row = i / 2;
        NSInteger line = i % 2;
        YLInformationView *view = self.views[i];
        view.frame = CGRectMake(line * viewW + LeftMargin, viewH * row, viewW, viewH);
    }
    
    NSInteger count = self.views.count / 2;
    self.line.frame = CGRectMake(0, viewH * count + TopMargin, self.frame.size.width, 1);
}

- (void)setModel:(YLSubDetailModel *)model {
    _model = model;
    if (!model) {
        return;
    }
    NSMutableArray *informations = [NSMutableArray array];
    if (model.course) {
        [informations addObject:model.course];
    } else {
        [informations addObject:@""];
    }
    if (model.licenseTime) {
        [informations addObject:model.licenseTime];
    } else {
        [informations addObject:@""];
    }
    if (model.location) {
        [informations addObject:model.location];
    } else {
        [informations addObject:@""];
    }
    if (model.meetingPlace) {
        [informations addObject:model.meetingPlace];
    } else {
        [informations addObject:@""];
    }
    if (model.emission) {
        [informations addObject:[NSString stringWithFormat:@"%@", model.emission]];
    } else {
        [informations addObject:@""];
    }
    if (model.emissionStandard) {
        [informations addObject:model.emissionStandard];
    } else {
        [informations addObject:@""];
    }
    if (model.gearbox) {
        [informations addObject:model.gearbox];
    } else {
        [informations addObject:@""];
    }
    if (model.transfer) {
        [informations addObject:model.transfer];
    } else {
        [informations addObject:@""];
    }
    if (model.annualInspection) {
        [informations addObject:model.annualInspection];
    } else {
        [informations addObject:@""];
    }
    if (model.commercialInsurance) {
        [informations addObject:model.commercialInsurance];
    } else {
        [informations addObject:@""];
    }
    if (model.trafficInsurance) {
        [informations addObject:model.trafficInsurance];
    } else {
        [informations addObject:@""];
    }
    
    [informations addObject:@""];
    
    for (NSInteger i = 0; i < self.views.count; i++) {
        YLInformationView *view = self.views[i];
        view.detailTitle = informations[i];
    }
    
}

- (NSMutableArray *)views {
    if (!_views) {
        _views = [NSMutableArray array];
    }
    return _views;
}

@end
