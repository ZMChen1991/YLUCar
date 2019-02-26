//
//  YLSeriesController.m
//  YLGoodCard
//
//  Created by lm on 2018/11/22.
//  Copyright © 2018 Chenzhiming. All rights reserved.
//

#import "YLSeriesController.h"
#import "YLSeriesModel.h"
#import "YLRequest.h"
//#import "YLTabBarController.h"
//#import "YLNavigationController.h"
//#import "YLBuyController.h"


@interface YLSeriesController ()

@property (nonatomic, strong) NSArray *series;

@end

@implementation YLSeriesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择车系";
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self loadData];
}

- (void)loadData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = self.model.brandId;
    NSString *urlString = [NSString stringWithFormat:@"%@/vehicle?method=series", YLCommandUrl];
    __weak typeof(self) weakSelf = self;
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            weakSelf.series = [YLSeriesModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [weakSelf.tableView reloadData];
        } else {
            [NSString showMessage:@"获取车系失败,请稍后重试"];
        }
    } failed:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.series.count;
}

#pragma mark 循环利用cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"YLSeriesController";
    // 1.拿到一个标识先去缓存池中查找对应的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 2.如果缓存池中没有，才需要传入一个标识创新的cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    YLSeriesModel *model = self.series[indexPath.row];
    cell.textLabel.text = model.series;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLSeriesModel *model = self.series[indexPath.row];
    if (self.buySeriesBlock) {
        self.buySeriesBlock(model.series);
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (NSArray *)series {
    if (!_series) {
        _series = [NSArray array];
    }
    return _series;
}

@end
