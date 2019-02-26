//
//  YLSoldOutSellOrderController.m
//  YLUCar
//
//  Created by lm on 2019/2/19.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLSoldOutSellOrderController.h"
#import "YLSaleOrderCell.h"
#import "YLSaleOrderCellFrame.h"
#import "YLSaleOrderModel.h"
#import "YLAccount.h"
#import "YLAccountTool.h"
#import "YLRequest.h"
#import "YLNoneView.h"
#import "YLSellOrderDetailController.h"

#define YLSoldOutSaleOrderPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SoldOutSaleOrder.txt"]

@interface YLSoldOutSellOrderController ()

@property (nonatomic, strong) NSMutableArray *saleOrders;
@property (nonatomic, strong) YLNoneView *noneView;
@end

@implementation YLSoldOutSellOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
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
    
    [self.saleOrders removeAllObjects];
    YLAccount *account = [YLAccountTool account];
    NSString *urlString = [NSString stringWithFormat:@"%@/sell?method=my", YLCommandUrl];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.telephone forKey:@"telephone"];
    [param setValue:@"0" forKey:@"status"];
    __weak typeof(self) weakSelf = self;
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            [weakSelf keyedArchiverObject:responseObject toFile:YLSoldOutSaleOrderPath];
            [weakSelf getLocalData];
            [hub removeFromSuperview];
        } else {
            [hub removeFromSuperview];
        }
    } failed:nil];
    
}

- (void)getLocalData {
    
    [self.saleOrders removeAllObjects];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLSoldOutSaleOrderPath];
    NSArray *modelArray = [YLSaleOrderModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
    for (YLSaleOrderModel *model in modelArray) {
        YLSaleOrderCellFrame *cellFrame = [[YLSaleOrderCellFrame alloc] init];
        cellFrame.model = model;
        [self.saleOrders addObject:cellFrame];
    }
    if (self.saleOrders.count == 0 || self.saleOrders == nil) {
        self.noneView.hidden = NO;
    } else {
        self.noneView.hidden = YES;
    }
    [self.tableView reloadData];
}

- (void)keyedArchiverObject:(id)obj toFile:(NSString *)filePath {
    BOOL success = [NSKeyedArchiver archiveRootObject:obj toFile:filePath];
    if (success) {
        NSLog(@"数据保存成功");
    } else {
        NSLog(@"保存失败");
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.saleOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLSaleOrderCell *cell = [YLSaleOrderCell cellWithTableView:tableView];
    YLSaleOrderCellFrame *cellFrame = self.saleOrders[indexPath.row];
    cell.saleOrderCellFrame = cellFrame;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLSaleOrderCellFrame *cellFrame = self.saleOrders[indexPath.row];
    return cellFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLSaleOrderCellFrame *cellFrame = self.saleOrders[indexPath.row];
    YLSellOrderDetailController *detail = [[YLSellOrderDetailController alloc] init];
    detail.model = cellFrame.model;
    [self.navigationController pushViewController:detail animated:YES];
}

- (NSMutableArray *)saleOrders {
    if (!_saleOrders) {
        _saleOrders = [NSMutableArray array];
    }
    return _saleOrders;
}

- (YLNoneView *)noneView {
    if (!_noneView) {
        _noneView = [[YLNoneView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, YLScreenHeight)];
        _noneView.title = @"暂无相关订单";
        _noneView.image = @"暂无订单";
        _noneView.hidden = YES;
        [_noneView hideBtn];
        [self.view addSubview:_noneView];
    }
    return _noneView;
}@end
