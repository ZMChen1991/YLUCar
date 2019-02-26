//
//  YLDetailViewController.m
//  YLUCar
//
//  Created by lm on 2019/2/11.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLDetailViewController.h"
#import "YLDetailHeaderView.h"
#import "YLTableGroupHeader.h"
#import "YLSafeguardCell.h"
#import "YLInformationCell.h"
#import "YLReportCell.h"
#import "YLCarInformationCell.h"
#import "YLDetailFooterView.h"
#import "YLDetailViewBar.h"
#import "YLRequest.h"
#import "YLCommandModel.h"
#import "YLAccount.h"
#import "YLAccountTool.h"
#import "YLDetailModel.h"
#import "YLSubDetailModel.h"
#import "YLDetailBannerModel.h"
#import "YLBargainPriceView.h"
#import "YLLoginController.h"
#import "YLOrderCarDetailView.h"
#import "YLConfigController.h"

// 详情页数据
#define YLDetailPath(carID) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:carID]

@interface YLDetailViewController () <UITableViewDelegate, UITableViewDataSource, YLTableGroupHeaderDelegate, YLDetailViewBarDelegate, YLDetailHeaderViewDelegate, YLBargainPriceViewDelegate, YLReportCellDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) YLDetailHeaderView *headerView;
@property (nonatomic, assign) YLDetailFooterView *footerView;
@property (nonatomic, assign) YLDetailViewBar *detailViewBar;
@property (nonatomic, strong) YLBargainPriceView *bargainPriceView;
@property (nonatomic, strong) YLOrderCarDetailView *orderCar;

@property (nonatomic, strong) YLDetailModel *detailModel;
@property (nonatomic, strong) NSArray *vehicles;
@property (nonatomic, strong) NSArray *blemishs;

@property (nonatomic, strong) NSMutableArray *browsingHistory;
@property (nonatomic, strong) UIView *cover;

@end

@implementation YLDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车辆详情";
    self.view.backgroundColor = YLColor(245.f, 245.f, 245.f);
    
    [self createTableView];
    [self getLocalData];
    [self loadData];
    
}

- (void)refreshData {
    [self loadData];
    [self.tableView.mj_header endRefreshing];
}

- (void)createTableView {
    
    CGFloat barHeight = 60;
    CGFloat tableViewH = YLScreenHeight - 64 - barHeight;
    if (KIsiPhoneX) {
        tableViewH -= 34;
    }
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, tableViewH)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    CGRect rect = CGRectMake(0, 0, YLScreenWidth, 370);
    YLDetailHeaderView *headerView = [[YLDetailHeaderView alloc] initWithFrame:rect];
    headerView.delegate = self;
    tableView.tableHeaderView = headerView;
    self.headerView = headerView;
    
    CGRect footerRect = CGRectMake(0, 0, YLScreenWidth, 220 + 2 * Margin);
    YLDetailFooterView *footerView = [[YLDetailFooterView alloc] initWithFrame:footerRect];
    tableView.tableFooterView = footerView;
    self.footerView = footerView;
    
    CGRect barRect = CGRectMake(0, CGRectGetMaxY(tableView.frame), YLScreenWidth, barHeight);
    YLDetailViewBar *detailViewBar = [[YLDetailViewBar alloc] initWithFrame:barRect];
    detailViewBar.delegate = self;
    [self.view addSubview:detailViewBar];
    self.detailViewBar = detailViewBar;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        YLSafeguardCell *cell = [YLSafeguardCell cellWithTable:tableView];
        return cell;
    } else if (indexPath.section == 1) {
        YLInformationCell *cell = [YLInformationCell cellWithTableView:tableView];
        cell.model = self.detailModel.detail;
        return cell;
    } else if (indexPath.section == 2) {
        YLReportCell *cell = [YLReportCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.model = self.detailModel.detail;
        return cell;
    }  else {
        YLCarInformationCell *cell = [YLCarInformationCell cellWithTableView:tableView];
        cell.vehicles = self.vehicles;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 136;
    } else if (indexPath.section == 1) {
        return 211;
    } else if (indexPath.section == 2) {
        return 455;
    }  else {
        return (225 + TopMargin) * 6;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect rect = CGRectMake(0, 0, YLScreenWidth, 44);
    NSArray *titles = @[@"服务保障",@"基本信息",@"检测报告",@"车辆图文"];
    NSArray *images = @[@"服务保障", @"基本信息", @"检测报告", @"车辆图文"];
    NSArray *details = @[@"", @"查看更多配置", @"", @""];
    NSArray *arrowImages = @[@"w", @"更多", @"w", @"w"];
    YLTableGroupHeader *header = [[YLTableGroupHeader alloc] initWithFrame:rect image:images[section] title:titles[section] detailTitle:details[section] arrowImage:arrowImages[section]];
    header.backgroundColor = [UIColor whiteColor];
    if (section == 1) {
        header.delegate = self;
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

#pragma mark 私有方法
- (void)priceRemind {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"新车价价=厂商公布的j指导价+购置税费，改价格仅供参考"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好的"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                NSLog(@"好的");
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)pushMoreControl {
    NSLog(@"更多配置");
    YLConfigController *config = [[YLConfigController alloc] init];
    config.model = self.detailModel;
    [self.navigationController pushViewController:config animated:YES];
}

- (void)clickToPictureModelInIndex:(NSInteger)index {
    NSLog(@"查看大图");
}

- (void)consultCustom {
    NSLog(@"联系客服");
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", customerServicePhone];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}

- (void)reportCellConsult {
    NSLog(@"咨询车辆所在的检测中心");
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", self.detailModel.detail.centerPhone];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}

- (void)tapClick:(UITapGestureRecognizer *)sender {
    NSLog(@"tapClick");
    [self.cover removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.bargainPriceView] || [touch.view isDescendantOfView:self.orderCar]) {
        return NO;
    }
    return YES;
}

- (void)showBargainPriceView {
    
    YLAccount *account = [YLAccountTool account];
    if (account) {
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        UIView *cover = [[UIView alloc] initWithFrame:window.bounds];
        cover.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3];
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        tap.delegate = self;
        [cover addGestureRecognizer:tap];
        [window addSubview:cover];
        self.cover = cover;
        
        CGFloat viewH = 160;
        CGFloat viewY = (YLScreenHeight - viewH) / 2;
        CGFloat viewW = YLScreenWidth - 2 * LeftMargin;
        CGRect rect = CGRectMake(LeftMargin, viewY, viewW, viewH);
        YLBargainPriceView *bargainPriceView = [[YLBargainPriceView alloc] initWithFrame:rect];
        bargainPriceView.delegate = self;
        [cover addSubview:bargainPriceView];
        self.bargainPriceView = bargainPriceView;
    } else {
        [self skipLoginController];
    }
    
}

- (void)skipLoginController {
    NSLog(@"跳转到登录控制器");
    __weak typeof(self) weakSelf = self;
    YLLoginController *login = [[YLLoginController alloc] init];
    login.loginBlock = ^(NSString * _Nonnull telephone) {
        [weakSelf loadData];
    };
    [self.navigationController pushViewController:login animated:YES];
}


- (void)bargainPrice {
    NSLog(@"底部砍价");
    [self showBargainPriceView];
}

- (void)bargain {
    NSLog(@"头部砍价");
    [self showBargainPriceView];
}

#pragma mark 预约看车代理
- (void)orderLookCar {
    NSLog(@"预约看车");
    YLAccount *account = [YLAccountTool account];
    if (account) {
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        UIView *cover = [[UIView alloc] initWithFrame:window.bounds];
        cover.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3];
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        tap.delegate = self;
        [cover addGestureRecognizer:tap];
        [window addSubview:cover];
        self.cover = cover;
        
        CGFloat viewH = 191.f;
        CGFloat viewY = (YLScreenHeight - viewH) / 2;
        CGFloat viewW = YLScreenWidth;
        CGRect rect = CGRectMake(0, viewY, viewW, viewH);
        __weak typeof(self) weakSelf = self;
        // 预约看车视图的取消
        YLOrderCarDetailView *orderCar = [[YLOrderCarDetailView alloc] initWithFrame:rect];
        orderCar.orderCarDetailCancelBlock = ^{
            [cover removeFromSuperview];
        };
        // 预约看车视图的确定
        orderCar.orderCarDetailSureBlock = ^(NSString * _Nonnull orderCarTime) {
            NSLog(@"orderCarTime:%@", orderCarTime);
            // 向后台发送预约看车请求
            UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
            MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:window];
            [window addSubview:hub];
            hub.detailsLabel.text = @"正在加载中";
            [hub showAnimated:YES];
            
            NSString *urlString = [NSString stringWithFormat:@"%@/buy?method=order", YLCommandUrl];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:weakSelf.detailModel.detail.telephone forKey:@"seller"];
            [param setObject:account.telephone forKey:@"buyer"];
            [param setObject:weakSelf.detailModel.detail.carID forKey:@"detailId"];
            [param setObject:weakSelf.detailModel.detail.centerId forKey:@"centerId"];
            [param setObject:orderCarTime forKey:@"appointTime"];
            
            [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
                if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
                    [weakSelf loadData];
                    [hub removeFromSuperview];
                    [NSString showMessage:@"预约成功"];
                } else {
                    [hub removeFromSuperview];
                    [NSString showMessage:[NSString stringWithFormat:@"%@", responseObject[@"message"]]];
                }
            } failed:nil];
            
          [cover removeFromSuperview];
        };
        [cover addSubview:orderCar];
        self.orderCar = orderCar;
    } else {
        [self skipLoginController];
    }
}
#pragma mark 砍价视图代理
- (void)cancelBargainPrice {
    NSLog(@"取消砍价");
    [self.cover removeFromSuperview];
}

- (void)sureBargainPrice:(NSString *)bargainPrice {
    NSLog(@"确定砍价：%@", bargainPrice);
    [self.cover removeFromSuperview];
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:hub];
    hub.detailsLabel.text = @"正在加载中";
    [hub showAnimated:YES];
    
    YLAccount *account = [YLAccountTool account];
    __weak typeof(self) weakSelf = self;
    NSString *price = [NSString stringWithFormat:@"%ld", [bargainPrice integerValue] * 10000];
    NSString *urlString = [NSString stringWithFormat:@"%@/bargain?method=dicker", YLCommandUrl];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:price forKey:@"price"];
    [param setObject:weakSelf.detailModel.detail.telephone forKey:@"seller"];
    [param setObject:account.telephone forKey:@"buyer"];
    [param setObject:weakSelf.detailModel.detail.carID forKey:@"detailId"];
    [param setObject:@"1" forKey:@"mark"];
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            [hub removeFromSuperview];
            [NSString showMessage:@"砍价成功"];
        } else {
            [hub removeFromSuperview];
            [NSString showMessage:[NSString stringWithFormat:@"%@", responseObject[@"message"]]];
        }
    } failed:nil];
}

#pragma mark 收藏车辆代理
- (void)collectCar {
    NSLog(@"收藏车辆");
    YLAccount *account = [YLAccountTool account];
    if (account) {
        // 收藏车辆

        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:window];
        [window addSubview:hub];
        hub.detailsLabel.text = @"正在加载中";
        [hub showAnimated:YES];
        
        NSString *urlString = [NSString stringWithFormat:@"%@/collection?method=upd", YLCommandUrl];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:account.telephone forKey:@"telephone"];
        [param setObject:self.detailModel.detail.carID forKey:@"detailId"];
        NSString *status;
        if ([self.detailModel.isCollect isEqualToString:@"1"]) {
            status = @"0";
        } else {
            status = @"1";
        }
        [param setObject:status forKey:@"status"];
        __weak typeof(self) weakSelf = self;
        [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
            if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
                [weakSelf loadData];
                [hub removeFromSuperview];
                if ([status isEqualToString:@"1"]) {
                    [NSString showMessage:@"收藏成功"];
                } else {
                    [NSString showMessage:@"取消收藏成功"];
                }
                
            } else {
                [hub removeFromSuperview];
                [NSString showMessage:@"收藏失败"];
            }
        } failed:nil];
        
    } else {
        [self skipLoginController];
    }
}


#pragma mark 数据加载
- (void)loadData {
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:hub];
    hub.detailsLabel.text = @"正在加载中";
    [hub showAnimated:YES];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/detail?method=id", YLCommandUrl];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.model.carID) {
        [param setObject:self.model.carID forKey:@"id"];
    }
    YLAccount *account = [YLAccountTool account];
    if (account) {
        [param setObject:account.telephone forKey:@"telephone"];
    }
    __weak typeof(self) weakSelf = self;
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            [hub removeFromSuperview];
            [weakSelf keyedArchiverObject:responseObject toFile:YLDetailPath(weakSelf.model.carID)];
            [weakSelf getLocalData];
            [weakSelf saveBrowseHistory:weakSelf.model];
        } else {
            [hub removeFromSuperview];
            [NSString showMessage:@"网络错误,请稍后再试"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failed:nil];
}

- (void)getLocalData {
    NSDictionary *detail = [NSKeyedUnarchiver unarchiveObjectWithFile:YLDetailPath(self.model.carID)];
    self.detailModel = [YLDetailModel mj_objectWithKeyValues:detail[@"data"]];
    self.vehicles = [YLDetailBannerModel mj_objectArrayWithKeyValuesArray:detail[@"data"][@"image"][@"vehicle"]];
    self.blemishs = [YLDetailBannerModel mj_objectArrayWithKeyValuesArray:detail[@"data"][@"image"][@"blemish"]];
    
    self.headerView.detail = detail;
    self.footerView.models = self.blemishs;
    self.detailViewBar.model = self.detailModel;
    [self.tableView reloadData];
    
#warning 这里需要做一些逻辑判断，判断车辆是否在售状态，或者下架状态时，非取消状态，判断用户是否已经购买该车辆
//    if ([self.detailModel.detail.status isEqualToString:@"4"]) {
//        [NSString showMessage:@"此车已下架,无法查看详情"];
//    }
}

- (void)keyedArchiverObject:(id)obj toFile:(NSString *)filePath {
    BOOL success = [NSKeyedArchiver archiveRootObject:obj toFile:filePath];
    if (success) {
        NSLog(@"数据保存成功");
    } else {
        NSLog(@"保存失败");
    }
}

/**
 保存浏览记录
 
 @param model 浏览模型对象
 */
- (void)saveBrowseHistory:(YLCommandModel *)model {
    
    // 判断浏览记录是否已经存在，如果存在，删除旧的，重新添加到数组
    // 遍历的时候不能操作删除和插入，不然会报错
    for (YLCommandModel *historyModel in self.browsingHistory) {
        if ([historyModel.carID isEqualToString:model.carID]) {
            NSInteger index = [self.browsingHistory indexOfObject:historyModel];
            [self.browsingHistory removeObjectAtIndex:index];
            NSLog(@"已删除旧的");
            break;
        }
    }
    [self.browsingHistory insertObject:model atIndex:0];
    
    // 保存到本地
    BOOL success = [NSKeyedArchiver archiveRootObject:self.browsingHistory toFile:YLBrowsingHistoryPath];
    if (success) {
        NSLog(@"浏览记录保存成功：%@", YLBrowsingHistoryPath);
        // 保存浏览记录，更新我的浏览记录数
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHMINEVIEW object:nil];
    } else {
        NSLog(@"浏览保存失败");
    }
}


- (void)setModel:(YLCommandModel *)model {
    _model = model;
}

- (NSMutableArray *)browsingHistory {
    
    if (!_browsingHistory) {
        _browsingHistory = [NSKeyedUnarchiver unarchiveObjectWithFile:YLBrowsingHistoryPath];
        if (!_browsingHistory) {
            _browsingHistory = [NSMutableArray array];
        }
    }
    return _browsingHistory;
}

@end
