//
//  YLLookCarSoldOutController.m
//  YLUCar
//
//  Created by lm on 2019/2/19.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLLookCarSoldOutController.h"
#import "YLAccount.h"
#import "YLAccountTool.h"
#import "YLRequest.h"
#import "YLLookCarCellFrame.h"
#import "YLLookCarModel.h"
#import "YLLookCarCell.h"
#import "YLNoneView.h"
#import "YLCommandModel.h"
#import "YLLookCarDetailModel.h"
#import "YLLookCarDetailController.h"

#define YLLookedCarSellingPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"LookedCarSelling.txt"]

@interface YLLookCarSoldOutController ()

@property (nonatomic, strong) NSMutableArray *lookCars;
@property (nonatomic, strong) YLNoneView *noneView;

@end

@implementation YLLookCarSoldOutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    [self getLocalData];
    [self loadData];
    
}
#pragma mark tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lookCars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLLookCarCellFrame *cellFrame = self.lookCars[indexPath.row];
    YLLookCarCell *cell = [YLLookCarCell cellWithTableView:tableView];
    cell.cellFrame = cellFrame;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [NSString showMessage:@"车辆已下架,无法查看详情"];
//    YLLookCarCellFrame *cellFrame = self.lookCars[indexPath.row];
//    YLLookCarDetailController *lookCarDetail = [[YLLookCarDetailController alloc] init];
//    lookCarDetail.model = cellFrame.model;
//    [self.navigationController pushViewController:lookCarDetail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YLLookCarCellFrame *cellFrame = self.lookCars[indexPath.row];
    return cellFrame.cellHeight;
}


- (void)loadData {
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:hub];
    hub.detailsLabel.text = @"正在加载中";
    [hub showAnimated:YES];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/buy?method=book", YLCommandUrl];
    __weak typeof(self) weakSelf = self;
    YLAccount *account = [YLAccountTool account];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:account.telephone forKey:@"telephone"];
    [param setObject:@"0" forKey:@"status"];
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            [weakSelf keyedArchiverObject:responseObject toFile:YLLookedCarSellingPath];
            [weakSelf getLocalData];
            [hub removeFromSuperview];
        } else {
            [hub removeFromSuperview];
        }
    } failed:nil];
    
}

- (void)getLocalData {
    
    [self.lookCars removeAllObjects];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLLookedCarSellingPath];
    NSArray *lookCarModels = [YLLookCarModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
    for (YLLookCarModel *model in lookCarModels) {
        YLLookCarCellFrame *cellFrame = [[YLLookCarCellFrame alloc] init];
        cellFrame.model = model;
        [self.lookCars addObject:cellFrame];
    }
    [self.tableView reloadData];
    
    if (self.lookCars.count > 0) {
        self.noneView.hidden = YES;
    } else {
        self.noneView.hidden = NO;
    }
}

- (void)keyedArchiverObject:(id)obj toFile:(NSString *)filePath {
    BOOL success = [NSKeyedArchiver archiveRootObject:obj toFile:filePath];
    if (success) {
        NSLog(@"即将看车下架数据保存成功");
    } else {
        NSLog(@"保存失败");
    }
}

- (NSMutableArray *)lookCars {
    if (!_lookCars) {
        _lookCars = [NSMutableArray array];
    }
    return _lookCars;
}

- (YLNoneView *)noneView {
    if (!_noneView) {
        _noneView = [[YLNoneView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, YLScreenHeight)];
        _noneView.title = @"暂无相关车辆";
        _noneView.image = @"暂无车源";
        _noneView.hidden = YES;
        [_noneView hideBtn];
        [self.view addSubview:_noneView];
    }
    return _noneView;
}

@end
