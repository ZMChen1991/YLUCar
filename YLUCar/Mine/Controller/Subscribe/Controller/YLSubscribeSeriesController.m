//
//  YLSubscribeSeriesController.m
//  YLGoodCard
//
//  Created by lm on 2019/1/18.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLSubscribeSeriesController.h"
//#import "YLBuyTool.h"
#import "YLSeriesModel.h"
#import "YLSubscribeMultiSelectController.h"
#import "YLRequest.h"

@interface YLSubscribeSeriesController ()

@property (nonatomic, strong) NSArray *series;
@end

@implementation YLSubscribeSeriesController

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
    UIViewController *target = nil;
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:[YLSubscribeMultiSelectController class]]) { //这里判断是否为你想要跳转的页面
            target = controller;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:YES]; //跳转
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSArray *)series {
    if (!_series) {
        _series = [NSArray array];
    }
    return _series;
}
@end
