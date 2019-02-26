//
//  YLOrderSaleCarController.m
//  YLUCar
//
//  Created by lm on 2019/2/14.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLOrderSaleCarController.h"
#import "YLSaleCarChoiceCell.h"
#import "YLSaleCarWriteCell.h"
#import "YLTimePicker.h"
#import "YLYearMonthPicker.h"
#import "YLYearMonthDayPicker.h"
#import "YLOrderSaleFooterView.h"
#import "YLDetectCenterController.h"
#import "YLDetectCenterModel.h"
#import "YLSaleCarBrandController.h"
#import "YLBrandModel.h"
#import "YLSeriesModel.h"
#import "YLCarTypeModel.h"
#import "YLRequest.h"
#import "YLReservationController.h"

@interface YLOrderSaleCarController () <YLOrderSaleFooterViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *detailTitles;

@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) YLDetectCenterModel *detectCenterModel;

@property (nonatomic, strong) YLYearMonthDayPicker *picker;
@property (nonatomic, strong) YLTimePicker *timePicker;
@property (nonatomic, strong) YLYearMonthPicker *yearMonthPick;
@property (nonatomic, strong) UIView *cover;

@end

@implementation YLOrderSaleCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约卖车";
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGRect rect = CGRectMake(0, 0, YLScreenWidth, 100);
    YLOrderSaleFooterView *footerView = [[YLOrderSaleFooterView alloc] initWithFrame:rect];
    footerView.delegate = self;
    self.tableView.tableFooterView = footerView;
    
    
    [self.param setObject:@"阳江" forKey:@"city"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 3 || indexPath.row == 5) {
        
        YLSaleCarWriteCell *cell = [YLSaleCarWriteCell cellWithTableView:tableView];
        cell.writeBlock = ^(NSString * _Nonnull detailTitle) {
            if ([detailTitle isEqualToString:@""]) {
                detailTitle = @"请输入";
            }
            if (indexPath.row == 3) {
                NSLog(@"3:%@", detailTitle);
                if (detailTitle) {
                    [weakSelf.param setObject:detailTitle forKey:@"location"];
                }
                [weakSelf.detailTitles replaceObjectAtIndex:indexPath.row withObject:detailTitle];
            } else {
                NSLog(@"5:%@", detailTitle);
                if (detailTitle) {
                    [weakSelf.param setObject:detailTitle forKey:@"course"];
                }
                [weakSelf.detailTitles replaceObjectAtIndex:indexPath.row withObject:detailTitle];
            }
        };
        cell.title = self.titles[indexPath.row];
        cell.detailTitle = self.detailTitles[indexPath.row];
        return cell;
    } else {
        YLSaleCarChoiceCell *cell = [YLSaleCarChoiceCell cellWithTableView:tableView];
        cell.choiceBlock = ^{
            if (indexPath.row == 1) {
                NSLog(@"检测中心");
                YLDetectCenterController *detectCenter = [[YLDetectCenterController alloc] init];
                detectCenter.city = @"阳江";
                detectCenter.detectCenterBlock = ^(YLDetectCenterModel * _Nonnull model) {
                    if (model) {
                        [weakSelf.param setObject:model.ID forKey:@"centerId"];
                    }
                    weakSelf.detectCenterModel = model;
                    [weakSelf.detailTitles replaceObjectAtIndex:indexPath.row withObject:model.name];
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                [weakSelf.navigationController pushViewController:detectCenter animated:YES];
            } else if (indexPath.row == 2) {
                NSLog(@"选择车型");
                YLSaleCarBrandController *brand = [[YLSaleCarBrandController alloc] init];
                brand.brandBlock = ^(YLBrandModel * _Nonnull brandModel, YLSeriesModel * _Nonnull seriesModel, YLCarTypeModel * _Nonnull carTypeModel) {
//                    NSLog(@"%@-%@-%@-%@", brandModel.brand, seriesModel.series, carTypeModel.typeName, carTypeModel.typeId);
                    NSString *brand = [NSString stringWithFormat:@"%@-%@-%@", brandModel.brand, seriesModel.series, carTypeModel.typeName];
                    if (carTypeModel) {
                        [weakSelf.param setObject:carTypeModel.typeId forKey:@"typeId"];
                    }
                    [weakSelf.detailTitles replaceObjectAtIndex:indexPath.row withObject:brand];
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                [weakSelf.navigationController pushViewController:brand animated:YES];
            } else if (indexPath.row == 4) {
                NSLog(@"上牌时间");
                UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
                UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, YLScreenHeight)];
                cover.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3];
                // 添加手势
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
                tap.delegate = self;
                [cover addGestureRecognizer:tap];
                [window addSubview:cover];
                self.cover = cover;
                
                YLYearMonthPicker *pick = [[YLYearMonthPicker alloc] initWithFrame:CGRectMake(0, 250, YLScreenWidth, 150)];
                pick.cancelBlock = ^{
                    [cover removeFromSuperview];
                };
                pick.sureBlock = ^(NSString * _Nonnull licenseTime) {
                    NSLog(@"licenseTime:%@", licenseTime);
                    if (licenseTime) {
                        [weakSelf.param setObject:licenseTime forKey:@"licenseTime"];
                    }
                    [weakSelf.detailTitles replaceObjectAtIndex:indexPath.row withObject:licenseTime];
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    [cover removeFromSuperview];
                };
                [cover addSubview:pick];
                self.yearMonthPick = pick;
            } else if (indexPath.row == 6) {
                NSLog(@"验车日期");
                UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
                UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, YLScreenHeight)];
                cover.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3];
                // 添加手势
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
                tap.delegate = self;
                [cover addGestureRecognizer:tap];
                [window addSubview:cover];
                self.cover = cover;
                
                YLYearMonthDayPicker *pick = [[YLYearMonthDayPicker alloc] initWithFrame:CGRectMake(0, 250, [UIScreen mainScreen].bounds.size.width, 150)];
                pick.cancelBlock = ^{
                    [cover removeFromSuperview];
                };
                pick.sureBlock = ^(NSString * _Nonnull licenseTime) {
                    [weakSelf.detailTitles replaceObjectAtIndex:indexPath.row withObject:licenseTime];
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    [cover removeFromSuperview];
                };
                [cover addSubview:pick];
                self.picker = pick;
            } else if (indexPath.row == 7) {
                NSLog(@"验车时间");
                UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
                UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, YLScreenHeight)];
                cover.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3];
                // 添加手势
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
                tap.delegate = self;
                [cover addGestureRecognizer:tap];
                [window addSubview:cover];
                self.cover = cover;
                
                YLTimePicker *pick = [[YLTimePicker alloc] initWithFrame:CGRectMake(0, 250, [UIScreen mainScreen].bounds.size.width, 150)];
                pick.cancelBlock = ^{
                    [cover removeFromSuperview];
                };
                pick.sureBlock = ^(NSString * _Nonnull time) {
                    NSLog(@"licenseTime:%@", time);
                    [weakSelf.detailTitles replaceObjectAtIndex:indexPath.row withObject:time];
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    [cover removeFromSuperview];
                };
                [cover addSubview:pick];
                self.timePicker = pick;
            } else {
                NSLog(@"联系电话");
                // 这里可以考虑使用writecell
            }
        };
        cell.title = self.titles[indexPath.row];
        cell.detailTitle = self.detailTitles[indexPath.row];
        return cell;
    }
}

- (void)tapClick:(UITapGestureRecognizer *)sender {
    NSLog(@"tapClick");
    [self.cover removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.picker] || [touch.view isDescendantOfView:self.timePicker] || [touch.view isDescendantOfView:self.yearMonthPick]) {
        return NO;
    }
    return YES;
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.view endEditing:YES];
//}

- (void)orderSaleInFooterView {
    NSLog(@"点击了预约卖车");
    [self.view endEditing:YES];
    
    if ([self isFullMessage]) {
        // 合并参数
        // 验车时间
        NSString *examineTime = [NSString stringWithFormat:@"%@ %@", self.detailTitles[6], self.detailTitles[7]];
        [self.param setObject:examineTime forKey:@"examineTime"];
        // 信息填写完整，上传后台
        NSString *urlString = [NSString stringWithFormat:@"%@/sell?method=order", YLCommandUrl];
        __weak typeof(self) weakSelf = self;
        [YLRequest GET:urlString parameters:self.param success:^(id  _Nonnull responseObject) {
            if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
//                [NSString showMessage:@"预约卖车成功"];
                YLReservationController *reservation = [[YLReservationController alloc] init];
                reservation.detectCenterModel = weakSelf.detectCenterModel;
                reservation.examineTime = examineTime;
                [self.navigationController pushViewController:reservation animated:YES];
            } else {
                NSLog(@"%@", responseObject[@"message"]);
            }
        } failed:nil];
    }
    
}

// 判断信息是否填写完整
- (BOOL)isFullMessage {
    BOOL isFull = YES;
    for (NSInteger i = 0; i < self.detailTitles.count; i++) {
        if ([self.detailTitles[i] isEqualToString:@"请选择"] || [self.detailTitles[i] isEqualToString:@"请输入"]) {
            [NSString showMessage:@"请将信息填写完整"];
            isFull = NO;
        }
    }
    return isFull;
}

- (void)freeConsultationInFooterView {
    NSLog(@"点击了免费咨询");
    
    [self.view endEditing:YES];
    
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", customerServicePhone];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}

- (void)setTelephone:(NSString *)telephone {
    _telephone = telephone;
    NSInteger count = self.detailTitles.count;
    [self.detailTitles replaceObjectAtIndex:count - 1 withObject:telephone];
    if (telephone) {
        [self.param setObject:telephone forKey:@"telephone"];
    }
}

- (NSMutableArray *)titles {
    if (!_titles) {
        _titles = [NSMutableArray arrayWithObjects:@"城市", @"检测中心", @"选择车型",@"上牌城市", @"上牌时间", @"行驶里程(单位:万公里)", @"验车日期", @"验车时间", @"联系电话", nil];
    }
    return _titles;
}

- (NSMutableArray *)detailTitles {
    if (!_detailTitles) {
        _detailTitles = [NSMutableArray arrayWithObjects:@"阳江",@"请选择",@"请选择",@"请输入",@"请选择",@"请输入",@"请选择",@"请选择", @"请选择", nil];
    }
    return _detailTitles;
}

- (NSMutableDictionary *)param {
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}

@end
