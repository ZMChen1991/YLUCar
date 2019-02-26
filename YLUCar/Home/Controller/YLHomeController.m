//
//  YLHomeController.m
//  YLUCar
//
//  Created by lm on 2019/1/28.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLHomeController.h"
#import "YLHomeCell.h"
#import "YLCommandModel.h"
#import "YLCommandCellFrame.h"
#import "YLRequest.h"
#import "SDCycleScrollView.h"
#import "YLBannerModel.h"
#import "YLNotableView.h"
#import "YLNotableModel.h"
#import "YLTableGroupHeader.h"
#import "YLBrandItemView.h"
#import "YLConditionParamModel.h"
#import "YLAboutController.h"
#import "YLDetailViewController.h"
#import "YLTabBarController.h"
#import "YLNavigationController.h"
#import "YLBuyCarController.h"
#import "YLBarButton.h"
#import "YLBarView.h"
#import "YLSearchCarController.h"

#define YLHomePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"home.txt"]
#define YLScrollImagePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ScrollImage.txt"]
#define YLNotableTitlePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"NotableTitle.txt"]

@interface YLHomeController () <UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, YLTableGroupHeaderDelegate, YLBrandItemViewDelegate, YLBarViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *banners;
@property (nonatomic, strong) NSMutableArray *notableTitles;

@property (nonatomic, strong) SDCycleScrollView *scroll;
@property (nonatomic, strong) YLNotableView *notableView;

@end

@implementation YLHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"YLHomeController");
    [self createTableView];
    [self setNav];
    [self getLocalScrollImage];
    [self getNotableTitle];
    [self getLoacalData];
    [self loadData];
}

- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, YLScreenHeight - 64)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    MJRefreshNormalHeader *mjHeader= [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    mjHeader.backgroundColor = [UIColor whiteColor];
    tableView.mj_header = mjHeader;
    [self.view addSubview:tableView];
    self.tableView = tableView;
 
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, 130 + 60 + 44 + 120 + 1)];
    header.backgroundColor = [UIColor clearColor];
    CGRect rect = CGRectMake(0, 0, YLScreenWidth, 130);
    SDCycleScrollView *scroll = [SDCycleScrollView cycleScrollViewWithFrame:rect delegate:self placeholderImage:nil];
    scroll.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [header addSubview:scroll];
    self.scroll = scroll;
    
    YLNotableView *notableView = [[YLNotableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scroll.frame), YLScreenWidth, 60)];
    [header addSubview:notableView];
    self.notableView = notableView;
    self.tableView.tableHeaderView = header;
    
    CGRect groupHeaderRect = CGRectMake(0, CGRectGetMaxY(notableView.frame), YLScreenWidth, 44);
    YLTableGroupHeader *groupHeader = [[YLTableGroupHeader alloc] initWithFrame:groupHeaderRect image:@"热门二手车" title:@"热门二手车" detailTitle:@"查看更多" arrowImage:@"更多"];
    groupHeader.delegate = self;
    [header addSubview:groupHeader];
    
    YLBrandItemView *brandItem = [[YLBrandItemView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(groupHeader.frame), YLScreenWidth, 120)];
//    brandItem.backgroundColor = [UIColor redColor];
    brandItem.delegate = self;
    [header addSubview:brandItem];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(brandItem.frame), YLScreenWidth, 1)];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [header addSubview:line];
}

- (void)setNav {
    YLBarButton *barButton = [YLBarButton buttonWithType:UIButtonTypeCustom];
    barButton.frame = CGRectMake(0, 0, 45, 44);
    barButton.title = @"阳江";
    barButton.icon = @"地区下拉";
    [barButton addTarget:self action:@selector(leftBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    // 添加搜索框视图
    CGFloat viewH = 44;
    CGFloat viewW = 255;
    CGFloat barVieH = 36;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
    YLBarView *barView = [[YLBarView alloc] initWithFrame:CGRectMake(TopMargin, (viewH - barVieH) / 2, viewW - TopMargin, barVieH)];
    barView.layer.cornerRadius = 5.f;
    barView.layer.masksToBounds = YES;
    barView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    barView.delegate = self;
    barView.icon = @"搜索";
    barView.title = @"搜索您想要的车";
    [view addSubview:barView];
    self.navigationItem.titleView = view;
}

- (void)leftBarButtonItemClick {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"暂时只支持阳江地区"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好的"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                NSLog(@"点击好的");
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)refreshData {
    // 刷新数据
    [self loadData];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark YLTableGroupHeader代理-查看更多
- (void)pushMoreControl {
    NSLog(@"查看更多");
    
    // 切换到买车页面
    YLConditionParamModel *model = nil;
    YLTabBarController *tab = (YLTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    YLNavigationController *nav = tab.viewControllers[1];
    YLBuyCarController *buy = nav.viewControllers.firstObject;
    buy.paramModel = model;
    tab.selectedIndex = 1;
}

- (void)pushSearchController {
    NSLog(@"跳转到搜索控制器");
    YLSearchCarController *searchCar = [[YLSearchCarController alloc] init];
    [self.navigationController pushViewController:searchCar animated:YES];
}

#pragma mark YLBrandItemView代理
- (void)choiceBrand:(YLConditionParamModel *)model {
    NSLog(@"%@ %@ %@", model.title, model.param, model.key);
    YLTabBarController *tab = (YLTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    YLNavigationController *nav = tab.viewControllers[1];
    YLBuyCarController *buy = nav.viewControllers.firstObject;
    buy.paramModel = model;
    tab.selectedIndex = 1;
}

#pragma mark 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLHomeCell *cell = [YLHomeCell cellWithTableView:tableView];
    YLCommandCellFrame *cellFrame = self.data[indexPath.row];
    cell.cellFrame = cellFrame;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSLog(@"didSelectRowAtIndexPath:%ld", indexPath.row);
    YLCommandCellFrame *cellFrame = self.data[indexPath.row];
    YLDetailViewController *detail = [[YLDetailViewController alloc] init];
    detail.model = cellFrame.model;
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YLCommandCellFrame *cellFrame = self.data[indexPath.row];
    return cellFrame.cellHeight;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"index:%ld", index);
    YLAboutController *about = [[YLAboutController alloc] init];
    [self.navigationController pushViewController:about animated:YES];
}

#pragma mark 数据加载
- (void)loadData {
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:hub];
    hub.detailsLabel.text = @"正在加载中";
    [hub showAnimated:YES];
    
    // 加载轮播图片
    NSString *bannerStr = [NSString stringWithFormat:@"%@/home?method=slide", YLCommandUrl];
    __weak typeof(self) weakSelf = self;
    [YLRequest GET:bannerStr parameters:nil success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
            [weakSelf keyedArchiverObject:responseObject toFile:YLScrollImagePath];
            [weakSelf getLocalScrollImage];
        } else {
            NSLog(@"bannerStr%@", responseObject[@"message"]);
        }
    } failed:nil];
    
    // 获取成交记录
    NSString *notableStr = [NSString stringWithFormat:@"%@/trade?method=random", YLCommandUrl];
    [YLRequest GET:notableStr parameters:nil success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInt:400]]) {
            NSLog(@"notableStr%@", responseObject[@"message"]);
        } else {
            [weakSelf keyedArchiverObject:responseObject toFile:YLNotableTitlePath];
            [weakSelf getNotableTitle];
            
        }
    } failed:nil];
    
    // 获取推荐列表
    NSString *urlString = [NSString stringWithFormat:@"%@/detail?method=recommend", YLCommandUrl];
//    __weak typeof(self) weakSelf = self;
    [YLRequest GET:urlString parameters:nil success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
            //            NSLog(@"responseObject:%@", responseObject);
            [weakSelf keyedArchiverObject:responseObject toFile:YLHomePath];
            [weakSelf getLoacalData];
            [hub removeFromSuperview];
        } else {
            NSLog(@"message:%@", responseObject[@"message"]);
            [hub removeFromSuperview];
        }
    } failed:nil];
}

- (void)getNotableTitle {
    
    [self.notableTitles removeAllObjects];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLNotableTitlePath];
    NSArray *array = [YLNotableModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
    for (YLNotableModel *model in array) {
        if (model.text) {
            [self.notableTitles addObject:model.text];
        }
    }
    self.notableView.titles = self.notableTitles;
}

- (void)getLocalScrollImage {
    [self.banners removeAllObjects];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLScrollImagePath];
    NSArray *array = [YLBannerModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
    for (YLBannerModel *model in array) {
        if (model.img) {
            [self.banners addObject:model.img];
        }
    }
    self.scroll.imageURLStringsGroup = self.banners;
}

- (void)getLoacalData {
    [self.data removeAllObjects];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLHomePath];
    NSArray *array = [YLCommandModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
    for (YLCommandModel *model in array) {
        YLCommandCellFrame *cellFrame = [[YLCommandCellFrame alloc] init];
        cellFrame.model = model;
        cellFrame.isLargeImage = NO;
        [self.data addObject:cellFrame];
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


#pragma mark 懒加载
- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (NSMutableArray *)banners {
    if (!_banners) {
        _banners = [NSMutableArray array];
    }
    return _banners;
}

- (NSMutableArray *)notableTitles {
    if (!_notableTitles) {
        _notableTitles = [NSMutableArray array];
    }
    return _notableTitles;
}

@end
