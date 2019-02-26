//
//  YLDepreciateController.m
//  YLGoodCard
//
//  Created by lm on 2018/11/30.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLDepreciateController.h"
#import "YLDepreciateCellFrame.h"
#import "YLDepreciateModel.h"
#import "YLDepreciateCell.h"
#import "YLDetailViewController.h"
#import "YLRequest.h"
#import "YLAccountTool.h"
#import "YLAccount.h"
#import "YLDepreciateModel.h"
#import "YLDepreciateCellFrame.h"
#import "YLNoneView.h"
#import "YLCommandModel.h"

#define YLDepreciatePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Depreciate.txt"]

@interface YLDepreciateController ()

@property (nonatomic, strong) NSMutableArray *depreciates;
@property (nonatomic, strong) YLNoneView *noneView;

@end

@implementation YLDepreciateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"降价提醒";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
        [weakSelf.tableView.mj_header endRefreshing];
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
    
    YLAccount *account = [YLAccountTool account];
    NSString *urlString = [NSString stringWithFormat:@"%@/reduce?method=my", YLCommandUrl];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:account.telephone forKey:@"telephone"];
    __weak typeof(self) weakSelf = self;
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
            NSLog(@"降价提醒请求成功");
            [weakSelf keyedArchiverObject:responseObject toFile:YLDepreciatePath];
            [weakSelf getLocalData];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHMINEVIEW object:nil];
            [hub removeFromSuperview];
        } else {
            NSLog(@"降价提醒请求失败");
            [hub removeFromSuperview];
        }
    } failed:nil];
}

- (void)getLocalData {
    
    [self.depreciates removeAllObjects];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLDepreciatePath];
    NSArray *array = [YLDepreciateModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
    for (YLDepreciateModel *model in array) {
        YLDepreciateCellFrame *cellFrame = [[YLDepreciateCellFrame alloc] init];
        cellFrame.model = model;
        [self.depreciates addObject:cellFrame];
    }
    if (self.depreciates.count == 0 || self.depreciates == nil) {
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
    return self.depreciates.count;
}

#pragma mark 循环利用cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLDepreciateCell *cell = [YLDepreciateCell cellWithTableView:tableView];
    YLDepreciateCellFrame *cellFrame = self.depreciates[indexPath.row];
    cell.cellFrame = cellFrame;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YLDepreciateCellFrame *cellFrame = self.depreciates[indexPath.row];
    return cellFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"查看当前降价情况跳转详情页");
    YLDepreciateCellFrame *cellFrame = self.depreciates[indexPath.row];
    YLDepreciateDetailModel *detailModel = cellFrame.model.detail;
    YLCommandModel *model = [YLCommandModel mj_objectWithKeyValues:detailModel];
    YLDetailViewController *detail = [[YLDetailViewController alloc] init];
    detail.model = model;
    [self.navigationController pushViewController:detail animated:YES];
}

- (NSMutableArray *)depreciates {
    if (!_depreciates) {
        _depreciates = [NSMutableArray array];
    }
    return _depreciates;
}

- (YLNoneView *)noneView {
    if (!_noneView) {
        _noneView = [[YLNoneView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, YLScreenHeight)];
        _noneView.title = @"暂无相关记录";
        _noneView.image = @"暂无订单";
        _noneView.hidden = YES;
        [_noneView hideBtn];
        [self.view addSubview:_noneView];
    }
    return _noneView;
}

@end
