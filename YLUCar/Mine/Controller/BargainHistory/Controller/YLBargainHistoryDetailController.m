//
//  YLBargainHistoryDetailController.m
//  YLUCar
//
//  Created by lm on 2019/2/21.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLBargainHistoryDetailController.h"
#import "YLCommandView.h"
#import "YLCommandViewFrame.h"
#import "YLCommandModel.h"
#import "YLBargainHistoryModel.h"
#import "YLRequest.h"
#import "YLAccount.h"
#import "YLAccountTool.h"
#import "YLBargainDetailModel.h"
#import "YLBargainDetailCellFrame.h"
#import "YLBargainHistoryDetailCell.h"
#import "YLBargainPriceView.h"
#import "YLAccepBargainPriceView.h"
#import "YLDetailViewController.h"

#define YLBargainHistoryDetailPath(carID) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"BargainHistoryDetail-%@", carID]]

@interface YLBargainHistoryDetailController () <YLBargainHistoryDetailCellDelegate, YLBargainPriceViewDelegate, YLAccepBargainPriceViewDelegate, YLCommandViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *dickers;
@property (nonatomic, strong) UIView *cover;
@property (nonatomic, strong) YLAccepBargainPriceView *accept;
@property (nonatomic, strong) YLBargainPriceView *bargainPriceView;


@property (nonatomic, strong) NSString *mark; // 标识：2是还价，1是砍价
@property (nonatomic, strong) YLBargainDetailModel *bargainDetailModel;
@end

@implementation YLBargainHistoryDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"砍价详情";
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self createView];
    
    [self getLocalData];
    [self loadData];
}

- (void) createView {
    
    YLCommandModel *commandModel = [YLCommandModel mj_objectWithKeyValues:self.model.detail];
    YLCommandViewFrame *viewFrame = [[YLCommandViewFrame alloc] init];
    viewFrame.model = commandModel;
    YLCommandView *commandView = [[YLCommandView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, viewFrame.viewHeight)];
    commandView.delegate = self;
    commandView.viewFrame = viewFrame;
    self.tableView.tableHeaderView = commandView;
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)loadData {
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:hub];
    hub.detailsLabel.text = @"正在加载中";
    [hub showAnimated:YES];
    
    YLAccount *account = [YLAccountTool account];
    NSString *urlString;
    if (self.isBuyer) {
        urlString = [NSString stringWithFormat:@"%@/bargain?method=binfo", YLCommandUrl];
        self.mark = @"1";
    } else {
        urlString = [NSString stringWithFormat:@"%@/bargain?method=sinfo", YLCommandUrl];
        self.mark = @"2";
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.model.detailId forKey:@"detailId"];
    [param setValue:account.telephone forKey:@"telephone"];
    __weak typeof(self) weakSelf = self;
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            [weakSelf keyedArchiverObject:responseObject toFile:YLBargainHistoryDetailPath(weakSelf.model.detailId)];
            [weakSelf getLocalData];
            [hub removeFromSuperview];
        } else {
            [NSString showMessage:[NSString stringWithFormat:@"%@", responseObject[@"message"]]];
            [hub removeFromSuperview];
        }
    } failed:nil];
}

- (void)getLocalData {
    
    [self.dickers removeAllObjects];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLBargainHistoryDetailPath(self.model.detailId)];
    NSArray *models = [YLBargainDetailModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
    for (YLBargainDetailModel *model in models) {
        model.isBuyer = self.isBuyer;
        YLBargainDetailCellFrame *cellFrame = [[YLBargainDetailCellFrame alloc] init];
        cellFrame.model = model;
        [self.dickers addObject:cellFrame];
    }
    [self.tableView reloadData];
}

- (void)keyedArchiverObject:(id)obj toFile:(NSString *)filePath {
    BOOL success = [NSKeyedArchiver archiveRootObject:obj toFile:filePath];
    if (success) {
        NSLog(@"即将看车下架数据保存成功");
    } else {
        NSLog(@"保存失败");
    }
}

- (void)tapClick:(UITapGestureRecognizer *)sender {
    NSLog(@"tapClick");
    [self.cover removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.bargainPriceView] || [touch.view isDescendantOfView:self.accept]) {
        return NO;
    }
    return YES;
}

#pragma mark 代理
- (void)clickCommandView {
    
    // 跳转详情页
    YLCommandModel *model = [YLCommandModel mj_objectWithKeyValues:self.model.detail];
    YLDetailViewController *detail = [[YLDetailViewController alloc] init];
    detail.model = model;
    [self.navigationController pushViewController:detail animated:YES];
}

// 接受砍价
- (void)accepBargainPrice:(YLBargainDetailModel *)bargainDetailModel {
    NSLog(@"accepBargainPrice");
    self.bargainDetailModel = bargainDetailModel;
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    UIView *cover = [[UIView alloc] initWithFrame:window.bounds];
    cover.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3];
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    tap.delegate = self;
    [cover addGestureRecognizer:tap];
    [window addSubview:cover];
    self.cover = cover;
    
    CGFloat viewH = 105;
    CGFloat viewY = (YLScreenHeight - viewH) / 2;
    CGFloat viewW =YLScreenWidth - 2 * LeftMargin;
    CGRect rect = CGRectMake(LeftMargin, viewY, viewW, viewH);
    YLAccepBargainPriceView *accept = [[YLAccepBargainPriceView alloc] initWithFrame:rect];
    accept.delegate = self;
    [cover addSubview:accept];
    self.accept = accept;
}

// 还价
- (void)dickBargainPrice:(YLBargainDetailModel *)bargainDetailModel {
    NSLog(@"dickBargainPrice");
    self.bargainDetailModel = bargainDetailModel;
    
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
    CGFloat viewW =YLScreenWidth - 2 * LeftMargin;
    CGRect rect = CGRectMake(LeftMargin, viewY, viewW, viewH);
    YLBargainPriceView *bargainPriceView = [[YLBargainPriceView alloc] initWithFrame:rect];
    bargainPriceView.delegate = self;
    [cover addSubview:bargainPriceView];
    self.bargainPriceView = bargainPriceView;
}

#pragma mark 还价
- (void)cancelBargainPrice {
    [self.cover removeFromSuperview];
}

- (void)sureBargainPrice:(NSString *)bargainPrice {
    [self.cover removeFromSuperview];
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:hub];
    hub.detailsLabel.text = @"正在加载中";
    [hub showAnimated:YES];
    
    // 请求还价
    NSLog(@"bargainPrice:%@", bargainPrice);
    NSString *price = [NSString stringWithFormat:@"%ld", [bargainPrice integerValue] * 10000];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.bargainDetailModel.detailId forKey:@"detailId"];
    [param setObject:self.bargainDetailModel.seller forKey:@"seller"];
    [param setObject:self.bargainDetailModel.buyer forKey:@"buyer"];
    [param setObject:price forKey:@"price"];
    [param setObject:self.mark forKey:@"mark"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/bargain?method=dicker", YLCommandUrl];
    __weak typeof(self) weakSelf = self;
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            [NSString showMessage:@"还价成功"];
            [weakSelf loadData];
            [hub removeFromSuperview];
            if (weakSelf.bargainHistoryDetailBlock) {
                weakSelf.bargainHistoryDetailBlock();
            }
        } else {
            [NSString showMessage:@"还价失败"];
            [hub removeFromSuperview];
        }
    } failed:nil];
}

#pragma mark 接受还价
- (void)cancelAccept {
    [self.cover removeFromSuperview];
}

- (void)sureAccept {
    [self.cover removeFromSuperview];
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:hub];
    hub.detailsLabel.text = @"正在加载中";
    [hub showAnimated:YES];
    
    // 确定接受还价
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.bargainDetailModel.detailId forKey:@"detailId"];
    [param setObject:self.bargainDetailModel.seller forKey:@"seller"];
    [param setObject:self.bargainDetailModel.buyer forKey:@"buyer"];
    [param setObject:self.bargainDetailModel.price forKey:@"price"];
    [param setObject:self.bargainDetailModel.bargainId forKey:@"id"];
    [param setObject:self.model.detail.centerId forKey:@"centerId"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/bargain?method=accept", YLCommandUrl];
    __weak typeof(self) weakSelf = self;
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            [NSString showMessage:@"已接受还价"];
            [weakSelf loadData];
            [hub removeFromSuperview];
            if (weakSelf.bargainHistoryDetailBlock) {
                weakSelf.bargainHistoryDetailBlock();
            }
        } else {
            [NSString showMessage:@"接受还价失败"];
            [hub removeFromSuperview];
        }
    } failed:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dickers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLBargainDetailCellFrame *cellFrame = self.dickers[indexPath.row];
    YLBargainHistoryDetailCell *cell = [YLBargainHistoryDetailCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.cellFrame = cellFrame;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YLBargainDetailCellFrame *cellFrame = self.dickers[indexPath.row];
    return cellFrame.cellHeight;
}

- (void)setModel:(YLBargainHistoryModel *)model {
    _model = model;
}

- (NSMutableArray *)dickers {
    if (!_dickers) {
        _dickers = [NSMutableArray array];
    }
    return _dickers;
}

@end
