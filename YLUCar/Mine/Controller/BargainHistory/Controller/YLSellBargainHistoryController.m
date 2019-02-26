//
//  YLSellBargainHistoryController.m
//  YLUCar
//
//  Created by lm on 2019/2/20.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLSellBargainHistoryController.h"
#import "YLBargainHistoryCellFrame.h"
#import "YLBargainHistoryModel.h"
//#import "YLBargainHistoryCell.h"
//#import "YLBargainHistoryDetailController.h"
#import "YLRequest.h"
#import "YLBargainHistoryModel.h"
#import "YLBargainHistoryCellFrame.h"
#import "YLAccount.h"
#import "YLAccountTool.h"
#import "YLSubSellerBargainHistoryCell.h"
#import "YLNoneView.h"
#import "YLBargainHistoryDetailController.h"

#define YLSellerBargainHistoryPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SellerBargainHistory.txt"]

@interface YLSellBargainHistoryController ()

@property (nonatomic, strong) NSMutableArray *sellerBargainHistorys;
@property (nonatomic, strong) YLNoneView *noneView;
@end

@implementation YLSellBargainHistoryController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
        [self.tableView.mj_header endRefreshing];
    }];
    [self getLocalData];
    [self loadData];
}

- (void)loadData {
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:hub];
    hub.detailsLabel.text = @"正在加载中";
    [hub showAnimated:YES];
    
    [self.sellerBargainHistorys removeAllObjects];
    YLAccount *account = [YLAccountTool account];
    NSString *urlString = [NSString stringWithFormat:@"%@/bargain?method=seller", YLCommandUrl];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.telephone forKey:@"telephone"];
    __weak typeof(self) weakSelf = self;
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        NSLog(@"YLSubSellerBargainHistoryController-urlString:%@-param:%@ \nresponseObject:%@",urlString, param, responseObject);
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            [weakSelf keyedArchiverObject:responseObject toFile:YLSellerBargainHistoryPath];
            [weakSelf getLocalData];
            [hub removeFromSuperview];
        } else {
            NSLog(@"请求失败");
            [hub removeFromSuperview];
        }
    } failed:nil];
}

- (void)getLocalData {
    
    [self.sellerBargainHistorys removeAllObjects];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLSellerBargainHistoryPath];
    NSArray *models = [YLBargainHistoryModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
    for (YLBargainHistoryModel *model in models) {
        YLBargainHistoryCellFrame *cellFrame = [[YLBargainHistoryCellFrame alloc] init];
        cellFrame.model = model;
        [self.sellerBargainHistorys addObject:cellFrame];
    }
    if (self.sellerBargainHistorys.count == 0 || self.sellerBargainHistorys == nil) {
        self.noneView.hidden = NO;
    } else {
        self.noneView.hidden = YES;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sellerBargainHistorys.count;
}

#pragma mark 循环利用cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLSubSellerBargainHistoryCell *cell = [YLSubSellerBargainHistoryCell cellWithTableView:tableView];
    YLBargainHistoryCellFrame *cellFrame = self.sellerBargainHistorys[indexPath.row];
    cell.cellFrame = cellFrame;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLBargainHistoryCellFrame *cellFrame = self.sellerBargainHistorys[indexPath.row];
    return cellFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    YLBargainHistoryCellFrame *cellFrame = self.sellerBargainHistorys[indexPath.row];
    YLBargainHistoryDetailController *detail = [[YLBargainHistoryDetailController alloc] init];
    detail.model = cellFrame.model;
    detail.isBuyer = NO;
    __weak typeof(self) weakSelf = self;
    detail.bargainHistoryDetailBlock = ^{
        [weakSelf loadData];
    };
    [self.navigationController pushViewController:detail animated:YES];
}

- (NSMutableArray *)sellerBargainHistorys {
    if (!_sellerBargainHistorys) {
        _sellerBargainHistorys = [NSMutableArray array];
    }
    return _sellerBargainHistorys;
}

- (YLNoneView *)noneView {
    if (!_noneView) {
        _noneView = [[YLNoneView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, YLScreenHeight)];
        _noneView.title = @"暂无相关记录";
        _noneView.hidden = YES;
        [_noneView hideBtn];
        [self.view addSubview:_noneView];
    }
    return _noneView;
}
@end
