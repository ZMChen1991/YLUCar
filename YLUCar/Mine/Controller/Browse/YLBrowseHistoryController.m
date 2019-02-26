//
//  YLBrowseHistoryController.m
//  YLUCar
//
//  Created by lm on 2019/2/15.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLBrowseHistoryController.h"
#import "YLHomeCell.h"
#import "YLCommandModel.h"
#import "YLCommandCellFrame.h"
#import "YLDetailViewController.h"
#import "YLNoneView.h"

@interface YLBrowseHistoryController ()

@property (nonatomic, strong) NSMutableArray *browseHistoryModels;
@property (nonatomic, strong) YLNoneView *noneView;

@end

@implementation YLBrowseHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"浏览记录";
    self.tableView.tableFooterView = [[UIView alloc] init];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getBrowseHistory];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    [self getBrowseHistory];
}

- (void)getBrowseHistory {
    
    [self.browseHistoryModels removeAllObjects];
    
    NSArray *browseHistory = [NSKeyedUnarchiver unarchiveObjectWithFile:YLBrowsingHistoryPath];
    for (YLCommandModel *model in browseHistory) {
        YLCommandCellFrame *cellFrame = [[YLCommandCellFrame alloc] init];
        cellFrame.model = model;
        cellFrame.isLargeImage = NO;
        [self.browseHistoryModels addObject:cellFrame];
    }
    [self.tableView reloadData];
    
    if (self.browseHistoryModels.count > 0) {
        self.noneView.hidden = YES;
    } else {
        self.noneView.hidden = NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.browseHistoryModels.count;
}

#pragma mark 循环利用cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLCommandCellFrame *cellFrame = self.browseHistoryModels[indexPath.row];
    YLHomeCell *cell = [YLHomeCell cellWithTableView:tableView];
    cell.cellFrame = cellFrame;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YLCommandCellFrame *cellFrame = self.browseHistoryModels[indexPath.row];
    return cellFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath:%ld", indexPath.row);
    YLCommandCellFrame *cellFrame = self.browseHistoryModels[indexPath.row];
    YLDetailViewController *detail = [[YLDetailViewController alloc] init];
    detail.model = cellFrame.model;
    [self.navigationController pushViewController:detail animated:YES];
}

- (NSMutableArray *)browseHistoryModels {
    if (!_browseHistoryModels) {
       _browseHistoryModels = [NSMutableArray array];
    }
    return _browseHistoryModels;
}

- (YLNoneView *)noneView {
    if (!_noneView) {
        _noneView = [[YLNoneView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, YLScreenHeight)];
        _noneView.title = @"暂无相关车辆";
        _noneView.image = @"暂无浏览";
        _noneView.hidden = YES;
        [_noneView hideBtn];
        [self.view addSubview:_noneView];
    }
    return _noneView;
}

@end
