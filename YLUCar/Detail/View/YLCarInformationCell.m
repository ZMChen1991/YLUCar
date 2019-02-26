//
//  YLCarInformationCell.m
//  YLUCar
//
//  Created by lm on 2019/2/15.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLCarInformationCell.h"
#import "YLCarInformationView.h"
#import "YLDetailModel.h"
#import "YLDetailBannerModel.h"

@interface YLCarInformationCell ()

@property (nonatomic, strong) NSMutableArray *carImages;
@property (nonatomic, strong) NSArray *carTitles;
@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, strong) UILabel *line;

@end

@implementation YLCarInformationCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YLCarInformationCell";
    YLCarInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YLCarInformationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.carTitles = @[@"正侧",@"正前",@"前排",@"后排",@"中控",@"发动机舱"];
    for (NSInteger i = 0; i < self.carTitles.count; i++) {
        YLCarInformationView *carView = [[YLCarInformationView alloc] init];
        carView.title = self.carTitles[i];
        [self addSubview:carView];
        [self.views addObject:carView];
    }
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [self addSubview:line];
    self.line = line;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat viewW = self.frame.size.width - 2 * LeftMargin;
    CGFloat viewH = 225;
    CGFloat margin = TopMargin;
    NSInteger count = self.views.count;
    for (NSInteger i = 0; i < count; i++) {
        YLCarInformationView *carView = self.views[i];
        carView.frame = CGRectMake(LeftMargin, i * (viewH + margin), viewW, viewH);
//        NSLog(@"%@", carView);
    }
}

- (void)setVehicles:(NSArray *)vehicles {
    _vehicles = vehicles;
    
    if (!vehicles) {
        return;
    }
    
//#warning 这里需要修改2019-02-20
//    NSMutableArray *models = [NSMutableArray array];
//    if (vehicles.count > 23) {
//        [models addObject:vehicles[0]];
//        [models addObject:vehicles[1]];
//        [models addObject:vehicles[19]];
//        [models addObject:vehicles[20]];
//        [models addObject:vehicles[11]];
//        [models addObject:vehicles[23]];
//    }
    
    NSMutableArray *models = [NSMutableArray array];
    YLDetailBannerModel *model = [[YLDetailBannerModel alloc] init];
    // 正则
    if (vehicles.count > 0) {
        [models addObject:vehicles[0]];
    } else {
        [models addObject:model];
    }
    // 正前
    if (vehicles.count > 1) {
        [models addObject:vehicles[1]];
    } else {
        [models addObject:model];
    }
    // 前排
    if (vehicles.count > 19) {
        [models addObject:vehicles[19]];
    } else {
        [models addObject:model];
    }
    // 后排
    if (vehicles.count > 20) {
        [models addObject:vehicles[20]];
    } else {
        [models addObject:model];
    }
    // 中控
    if (vehicles.count > 11) {
        [models addObject:vehicles[1]];
    } else {
        [models addObject:model];
    }
    // 发动机舱
    if (vehicles.count > 23) {
        [models addObject:vehicles[23]];
    } else {
        [models addObject:model];
    }
    
    for (NSInteger i = 0; i < models.count; i++) {
        YLCarInformationView *carView = self.views[i];
        YLDetailBannerModel *model = models[i];
        carView.image = model.img;
    }
    
}

- (NSMutableArray *)views {
    if (!_views) {
        _views = [NSMutableArray array];
    }
    return _views;
}

@end
