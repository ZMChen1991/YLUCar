//
//  YLRecheckBuyOrderController.m
//  YLUCar
//
//  Created by lm on 2019/2/19.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLRecheckBuyOrderController.h"
#import "YLBuyOrderCell.h"
#import "YLBuyOrderCellFrame.h"
#import "YLBuyOrderModel.h"
#import "YLRequest.h"
#import "YLAccountTool.h"
#import "YLAccount.h"
#import "YLBuyOrderModel.h"
#import "YLBuyOrderCellFrame.h"
#import "YLNoneView.h"
#import "YLBuyOrderDetailController.h"

#define YLRecheckBuyOrderPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"RecheckBuyOrder.txt"]

@interface YLRecheckBuyOrderController ()
@property (nonatomic, strong) NSMutableArray *buyOrders;
@property (nonatomic, strong) YLNoneView *noneView;

@end

@implementation YLRecheckBuyOrderController

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
    
    [self.buyOrders removeAllObjects];
    __weak typeof(self) weakSelf = self;
    YLAccount *account = [YLAccountTool account];
    NSString *urlString = [NSString stringWithFormat:@"%@/buy?method=my", YLCommandUrl];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.telephone forKey:@"telephone"];
    [param setValue:@"3" forKey:@"status"];
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
//        NSLog(@"param :%@ respronseObject:%@",param, responseObject);
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            [weakSelf keyedArchiverObject:responseObject toFile:YLRecheckBuyOrderPath];
            [weakSelf getLocalData];
            [hub removeFromSuperview];
        } else {
            [hub removeFromSuperview];
        }
    } failed:nil];
}

- (void)getLocalData {
    
    [self.buyOrders removeAllObjects];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLRecheckBuyOrderPath];
    NSArray *buyOrderModels = [YLBuyOrderModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
    for (YLBuyOrderModel *model in buyOrderModels) {
        YLBuyOrderCellFrame *cellFrame = [[YLBuyOrderCellFrame alloc] init];
        cellFrame.model = model;
        [self.buyOrders addObject:cellFrame];
    }
    if (self.buyOrders.count == 0 || self.buyOrders == nil) {
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
    return self.buyOrders.count;
}

#pragma mark 循环利用cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLBuyOrderCell *cell = [YLBuyOrderCell cellWithTableView:tableView];
    YLBuyOrderCellFrame *cellFrame = self.buyOrders[indexPath.row];
    cell.buyOrderCellFrame = cellFrame;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLBuyOrderCellFrame *cellFrame = self.buyOrders[indexPath.row];
    return cellFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLBuyOrderCellFrame *cellFrame = self.buyOrders[indexPath.row];
    YLBuyOrderModel *model = cellFrame.model;
    YLBuyOrderDetailController *buyOrderDetail = [[YLBuyOrderDetailController alloc] init];
    buyOrderDetail.model = model;
    [self.navigationController pushViewController:buyOrderDetail animated:YES];
}

- (NSMutableArray *)buyOrders {
    if (!_buyOrders) {
        _buyOrders = [NSMutableArray array];
    }
    return _buyOrders;
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
}
@end
