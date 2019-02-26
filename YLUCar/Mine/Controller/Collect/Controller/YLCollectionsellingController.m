//
//  YLCollectionsellingController.m
//  YLUCar
//
//  Created by lm on 2019/2/19.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLCollectionsellingController.h"
#import "YLAccount.h"
#import "YLAccountTool.h"
#import "YLRequest.h"
#import "YLCollectionModel.h"
#import "YLCollectCellFrame.h"
#import "YLCollectionCarCell.h"
#import "YLNoneView.h"
#import "YLDetailViewController.h"
#import "YLCommandModel.h"
#import "YLCollectionDetailModel.h"

#define YLCollectionsellingPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Collectionselling.txt"]

@interface YLCollectionsellingController ()

@property (nonatomic, strong) NSMutableArray *collectCars;
@property (nonatomic, strong) YLNoneView *noneView;

@end

@implementation YLCollectionsellingController

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
    return self.collectCars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLCollectCellFrame *cellFrame = self.collectCars[indexPath.row];
    YLCollectionCarCell *cell = [YLCollectionCarCell cellWithTableView:tableView];
    cell.cellFrame = cellFrame;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLCollectCellFrame *cellFrame = self.collectCars[indexPath.row];
    YLCommandModel *model = [YLCommandModel mj_objectWithKeyValues:cellFrame.model.detail];
    YLDetailViewController *detai = [[YLDetailViewController alloc] init];
    detai.model = model;
    [self.navigationController pushViewController:detai animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YLCollectCellFrame *cellFrame = self.collectCars[indexPath.row];
    return cellFrame.cellHeight;
}

- (void)loadData {
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:hub];
    hub.detailsLabel.text = @"正在加载中";
    [hub showAnimated:YES];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/collection?method=my", YLCommandUrl];
    __weak typeof(self) weakSelf = self;
    YLAccount *account = [YLAccountTool account];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:account.telephone forKey:@"telephone"];
    [param setObject:@"3" forKey:@"status"];
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            [weakSelf keyedArchiverObject:responseObject toFile:YLCollectionsellingPath];
            [weakSelf getLocalData];
            [hub removeFromSuperview];
        } else {
            [hub removeFromSuperview];
        }
    } failed:nil];
    
}

- (void)getLocalData {
    
    [self.collectCars removeAllObjects];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLCollectionsellingPath];
    NSArray *collectCarModels = [YLCollectionModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
    for (YLCollectionModel *model in collectCarModels) {
        YLCollectCellFrame *cellFrame = [[YLCollectCellFrame alloc] init];
        cellFrame.model = model;
        [self.collectCars addObject:cellFrame];
    }
    [self.tableView reloadData];
    
    if (self.collectCars.count > 0) {
        self.noneView.hidden = YES;
    } else {
        self.noneView.hidden = NO;
    }
}

- (void)keyedArchiverObject:(id)obj toFile:(NSString *)filePath {
    BOOL success = [NSKeyedArchiver archiveRootObject:obj toFile:filePath];
    if (success) {
        NSLog(@"数据保存成功");
    } else {
        NSLog(@"保存失败");
    }
}

- (NSMutableArray *)collectCars {
    if (!_collectCars) {
        _collectCars = [NSMutableArray array];
    }
    return _collectCars;
}

- (YLNoneView *)noneView {
    if (!_noneView) {
        _noneView = [[YLNoneView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, YLScreenHeight)];
        _noneView.title = @"暂无相关收藏";
        _noneView.hidden = YES;
        [_noneView hideBtn];
        [self.view addSubview:_noneView];
    }
    return _noneView;
}

@end
