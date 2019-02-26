//
//  YLBuyCarController.m
//  YLUCar
//
//  Created by lm on 2019/1/28.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLBuyCarController.h"
#import "YLHomeCell.h"
#import "YLCommandCellFrame.h"
#import "YLCommandModel.h"
#import "YLRequest.h"
#import "YLTitleLinkageView.h"
#import "YLSortView.h"
#import "YLConditionParamModel.h"
#import "YLCustomPrice.h"
#import "YLBrandController.h"
#import "YLSelectView.h"
#import "YLMultiSelectController.h"
#import "YLDetailViewController.h"
#import "YLConditionParamModel.h"
#import "YLBarButton.h"
#import "YLBarView.h"
#import "YLNoneView.h"
#import "YLConditionParamView.h"
#import "YLSearchCarController.h"

#define YLBuyCarPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"BuyCar.txt"]

@interface YLBuyCarController () <UITableViewDelegate, UITableViewDataSource, YLTitleLinkageViewDelegate, YLBarViewDelegate, YLNoneViewDelegate, YLConditionParamViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) NSMutableArray *sorts;
@property (nonatomic, strong) NSMutableArray *prices;
@property (nonatomic, strong) NSMutableArray *multiSelects;

@property (nonatomic, strong) YLConditionParamModel *lowPrice;
@property (nonatomic, strong) YLConditionParamModel *highPrice;

@property (nonatomic, strong) YLTitleLinkageView *linkage;
@property (nonatomic, strong) YLSortView *sortView;// 排序
@property (nonatomic, strong) YLCustomPrice *customPrice;// 价格
@property (nonatomic, strong) YLNoneView *noneView;
@property (nonatomic, strong) YLConditionParamView *paramView;

@property (nonatomic, strong) NSMutableDictionary *param;// 请求参数
@property (nonatomic, assign) BOOL isLargeImage;
@property (nonatomic, strong) NSMutableArray *selectParams; // 存放选中的参数


@end

@implementation YLBuyCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"YLBuyCarController");
    
    [self createTableView];
    [self setNavigationItem];
    [self yl__initData];
    [self loadData];
}

- (void)createTableView {
    CGFloat linkageH = 50;
    YLTitleLinkageView *linkage = [[YLTitleLinkageView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, linkageH)];
    linkage.delegate = self;
    [self.view addSubview:linkage];
    self.linkage = linkage;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, linkageH, YLScreenWidth, YLScreenHeight - 64 - linkageH)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MJRefreshNormalHeader *mjHeader= [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    mjHeader.backgroundColor = [UIColor whiteColor];
    tableView.mj_header = mjHeader;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    YLNoneView *noneView = [[YLNoneView alloc] initWithFrame:CGRectMake(0, linkageH, YLScreenWidth, YLScreenHeight - 64 - linkageH)];
    noneView.hidden = YES;
    noneView.delegate = self;
    noneView.title = @"暂无相关车源";
    noneView.image = @"暂无车源";
    [self.view addSubview:noneView];
    self.noneView = noneView;
    
    CGRect rect = CGRectMake(-YLScreenWidth, CGRectGetMaxY(linkage.frame), YLScreenWidth, linkageH);
    YLConditionParamView *paramView = [[YLConditionParamView alloc] initWithFrame:rect];
    paramView.delegate = self;
    [self.view addSubview:paramView];
    self.paramView = paramView;
}

- (void)setNavigationItem {
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"大图" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarClick)];
//    self.navigationItem.rightBarButtonItem = right;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    [self.navigationItem.rightBarButtonItem setImage:[[UIImage imageNamed:@"看图模式"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
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
- (void)rightBarButtonItemClick {
    
    self.isLargeImage = !self.isLargeImage;
    // 清空数据，重新加载
    NSArray *tempData = [NSArray arrayWithArray:self.data];
    [self.data removeAllObjects];
    for (YLCommandCellFrame *cellFrame in tempData) {
        cellFrame.isLargeImage = self.isLargeImage;
        [self.data addObject:cellFrame];
    }
    [self.tableView reloadData];
}

#pragma mark 初始化条件栏
- (void)yl__initData {
    
    [self.sorts removeAllObjects];
    [self.prices removeAllObjects];
    [self.multiSelects removeAllObjects];
    
    NSArray *sorts = @[@"最新上架", @"价格最低", @"价格最高", @"车龄最短", @"里程最少"];
    for (NSInteger i = 0; i < sorts.count; i++) {
        YLConditionParamModel *model = [[YLConditionParamModel alloc] init];
        model.title = sorts[i];
        model.param = [NSString stringWithFormat:@"%ld", i + 1];
        model.key = @"sort";
        model.detailTitle = sorts[i];
        model.isSelect = NO;
        [self.sorts addObject:model];
    }
    
    NSArray *titles = @[@"不限", @"3万以下", @"3-5万", @"5-7万", @"7-9万", @"9-12万", @"12-16万", @"16-20万", @"20万以上"];
    NSArray *params = @[@"", @"0fgf30000", @"30000fgf50000", @"50000fgf70000", @"70000fgf90000", @"90000fgf120000", @"120000fgf160000", @"160000fgf200000", @"200000fgf99999999"];
    for (NSInteger i = 0; i < titles.count; i++) {
        YLConditionParamModel *model = [[YLConditionParamModel alloc] init];
        model.param = params[i];
        model.title = titles[i];
        model.detailTitle = titles[i];
        model.key = @"price";
        model.isSelect = NO;
        [self.prices addObject:model];
    }
    YLConditionParamModel *lowModel = [[YLConditionParamModel alloc] init];
    self.lowPrice = lowModel;
    
    YLConditionParamModel *highModel = [[YLConditionParamModel alloc] init];
    self.highPrice = highModel;
    
    NSArray *data = @[@[@"两厢轿车", @"三厢轿车", @"跑车", @"SUV", @"MPV", @"面包车", @"皮卡"],
                      @[@"本地牌照", @"外地牌照"],
                      @[@"手动", @"自动"],
                      @[@"低于3年", @"3-5年", @"5-7年", @"7-9年", @"9-12年", @"12年以上"],
                      @[@"低于3万", @"3-5万", @"5-7万", @"7-9万", @"9-12万", @"12万以上"],
                      @[@"低于1.0L", @"1.0L-1.3L", @"1.3L-1.6L", @"1.6L-1.9L", @"1.9L-2.2L", @"2.2L以上"],
                      @[@"国二及以上", @"国三及以上", @"国四及以上", @"国五"],
                      @[@"黑色", @"白色", @"银灰色", @"深灰色", @"银色", @"绿色", @"红色", @"咖啡色", @"香槟色", @"蓝色", @"橙色", @"其他"],
                      @[@"2座", @"4座" ,@"5座" ,@"6座" ,@"7座以上"],
                      @[@"汽油", @"柴油", @"电动", @"油电混合", @"其他"],
                      @[@"德系", @"日系", @"美系", @"法系", @"韩系", @"国产", @"其他"],
                      @[@"全景天窗", @"车身稳定控制", @"倒车影像系统", @"真皮座椅", @"无钥匙进入",@"儿童座椅接口", @"倒车雷达", @"GPS导航"]];
    NSArray *params2 = @[@"bodyStructure", @"isLocal", @"gearbox", @"vehicleAge", @"course", @"emission", @"emissionStandard", @"color", @"seatsNum", @"fuelForm", @"country", @"other"];
    NSArray *params3 = @[@"panoramicSunroof", @"stabilityControl", @"reverseVideo", @"genuineLeather", @"keylessEntrySystem", @"childSeatInterface", @"parkingRadar", @"gps"];
    for (NSInteger i = 0; i < data.count; i++) {
        NSMutableArray *details = [NSMutableArray array];
        NSArray *array = data[i];
        if (i < data.count - 1) {
            for (NSInteger j = 0; j < array.count; j++) {
                YLConditionParamModel *model = [[YLConditionParamModel alloc] init];
                model.title = array[j];
                model.detailTitle = array[j];
                model.param = array[j];
                model.key = params2[i];
                model.isSelect = NO;
                [details addObject:model];
            }
        } else {
            for (NSInteger j = 0; j < array.count; j++) {
                YLConditionParamModel *model = [[YLConditionParamModel alloc] init];
                model.title = array[j];
                model.detailTitle = array[j];
                model.param = @"0";
                model.key = params3[j];
                model.isSelect = NO;
                [details addObject:model];
            }
        }
        [self.multiSelects addObject:details];
    }
}

- (void)removeContainParamModel:(YLConditionParamModel *)Parammodel {
    for (YLConditionParamModel *model in self.selectParams) {
        if ([model.key isEqualToString:Parammodel.key]) {
            [self.selectParams removeObject:model];
            break;
        }
    }
}

- (void)showConditionParamView {
    
    if (self.selectParams.count > 0) {
        // 有选中的参数显示出paramView
        CGRect rect = self.paramView.frame;
        rect.origin.x = 0;
        self.paramView.frame = rect;
        
        CGRect tableViewRect = CGRectMake(0, CGRectGetMaxY(self.paramView.frame), YLScreenWidth, YLScreenHeight - 64 - CGRectGetMaxY(self.linkage.frame) - CGRectGetHeight(self.paramView.frame));
        self.tableView.frame = tableViewRect;
    } else {
        // 没有选中的参数隐藏起来
        CGRect rect = self.paramView.frame;
        rect.origin.x = -YLScreenWidth;
        self.paramView.frame = rect;
        
        CGRect tableViewRect = CGRectMake(0, CGRectGetMaxY(self.linkage.frame), YLScreenWidth, YLScreenHeight - 64 - CGRectGetMaxY(self.linkage.frame));
        self.tableView.frame = tableViewRect;
    }
    // 将选中的参数显示出来
    self.paramView.params = self.selectParams;
    
    // 设置网络请求参数
    // 清空原请求参数，重新添加
    [self.param removeAllObjects];
    
    for (YLConditionParamModel *model in self.selectParams) {
        if ([model.key isEqualToString:@"isLocal"]) {
            [self.param setObject:@"阳江" forKey:@"location"];
        }
        // 如果请求参数中包含有相同的key，那么拼接key的值
        if ([[self.param allKeys] containsObject:model.key]) {
            NSString *obj = [self.param objectForKey:model.key];
            [self.param setObject:[NSString stringWithFormat:@"%@fgf%@", obj, model.param] forKey:model.key];
        } else {
            [self.param setObject:model.param forKey:model.key];
        }
    }
    
    NSLog(@"self.param:%@", self.param);
    // 遍历完选中的参数，设置好请求参数，重新获取数据
    [self loadData];
}


#pragma mark 代理方法
- (void)paramViewRemoveWithIndex:(NSInteger)index {
    // 移除选中的参数
    YLConditionParamModel *model = self.selectParams[index];
    model.isSelect = !model.isSelect;

    // 替换原数组的条件参数
    for (NSInteger i = 0; i < self.sorts.count; i++) {
        YLConditionParamModel *paramModel = self.sorts[i];
        if ([model.param isEqualToString:paramModel.param]) {
            paramModel.isSelect = !paramModel.isSelect;
            break;
        }
    }
    for (NSInteger i = 0; i < self.prices.count; i++) {
        YLConditionParamModel *paramModel = self.prices[i];
        if ([model.param isEqualToString:paramModel.param]) {
            paramModel.isSelect = !paramModel.isSelect;
            break;
        }
    }
    for (NSInteger i = 0; i < self.multiSelects.count; i++) {
        NSArray *models = self.multiSelects[i];
        for (NSInteger j = 0; j < models.count; j++) {
            YLConditionParamModel *paramModel = models[j];
            if ([model.param isEqualToString:paramModel.param]) {
                paramModel.isSelect = !paramModel.isSelect;
                break;
            }
        }
    }
    
    [self.selectParams removeObjectAtIndex:index];
    [self showConditionParamView];
}

- (void)paramViewRemoveAllObject {
    // 清空参数
    for (YLConditionParamModel *model in self.selectParams) {
        model.isSelect = !model.isSelect;
    }
    [self.selectParams removeAllObjects];
    [self yl__initData];// 重新初始化条件框
    [self showConditionParamView];
}
#pragma mark 看看其他车源
- (void)reloadData {
    NSLog(@"清空参数，重新请求数据");
    [self.param removeAllObjects];
    [self.selectParams removeAllObjects];
    [self showConditionParamView];
    [self loadData];
}

- (void)pushSearchController {
    NSLog(@"跳转到搜索控制器");
    YLSearchCarController *searchCar = [[YLSearchCarController alloc] init];
    [self.navigationController pushViewController:searchCar animated:YES];
}

- (void)tapClick:(UITapGestureRecognizer *)sender {
    NSLog(@"tapClick");
    self.linkage.isRest = YES;
    [sender.view removeFromSuperview];
}

// 排除子视图响应手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.sortView] || [touch.view isDescendantOfView:self.customPrice]) {
        return NO;
    }
    return YES;
}

- (void)linkageWithIndex:(NSInteger)index {
    NSLog(@"linkageWithIndex:%ld", index);
    __weak typeof(self) weakSelf = self;
    
    CGFloat viewY = 64 + 50;
    if (KIsiPhoneX) {// 判断是否iphoneX
        viewY += 24;
    }
    if (index == 0) {// 排序
        
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        UIView *cover = [[UIView alloc] initWithFrame:window.bounds];
        cover.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.1];
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        tap.delegate = self;
        [cover addGestureRecognizer:tap];
        
        [window addSubview:cover];
        self.linkage.isChange = YES;
        YLSortView *sortView = [[YLSortView alloc] initWithFrame:CGRectMake(0, viewY, YLScreenWidth, 230)];
        sortView.models = self.sorts;
        sortView.sortViewBlock = ^(NSArray *sortModels) {
            // 还原箭头，移除蒙版，
            weakSelf.linkage.isRest = YES;
            weakSelf.sorts = [NSMutableArray arrayWithArray:sortModels];
            [cover removeFromSuperview];
            
            // 添加选中的参数，显示到paramView并请求数据
            for (YLConditionParamModel *model in sortModels) {
                if (model.isSelect) {
                    [self removeContainParamModel:model];
                    [self.selectParams addObject:model];
                }
            }
            [self showConditionParamView];
        };
        [cover addSubview:sortView];
        self.sortView = sortView;
        
    } else if (index == 1) {// 品牌
        YLBrandController *brand = [[YLBrandController alloc] init];
        brand.buyBrandBlock = ^(NSString *brand, NSString *series) {
            YLConditionParamModel *brandModel = [[YLConditionParamModel alloc] init];
            brandModel.title = brand;
            brandModel.param = brand;
            brandModel.key = @"brand";
            brandModel.detailTitle = brand;
            brandModel.isSelect = YES;
            [self removeContainParamModel:brandModel];
            [self.selectParams addObject:brandModel];
            
            YLConditionParamModel *seriesModel = [[YLConditionParamModel alloc] init];
            seriesModel.title = series;
            seriesModel.param = series;
            seriesModel.key = @"series";
            seriesModel.detailTitle = series;
            seriesModel.isSelect = YES;
            [self removeContainParamModel:seriesModel];
            [self.selectParams addObject:seriesModel];
            
            [self showConditionParamView];
        };
        [self.navigationController pushViewController:brand animated:YES];
        
    } else if (index == 2) {// 价格
        
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        UIView *cover = [[UIView alloc] initWithFrame:window.bounds];
        cover.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.1];
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        tap.delegate = self;
        [cover addGestureRecognizer:tap];
        
        [window addSubview:cover];
        self.linkage.isChange = YES;
        YLCustomPrice *customPrice = [[YLCustomPrice alloc] initWithFrame:CGRectMake(0, viewY, YLScreenWidth, 230)];
        customPrice.models = self.prices;
        customPrice.customPriceBlock = ^(NSArray *priceModels) {
            weakSelf.linkage.isRest = YES;
            [cover removeFromSuperview];
            
            // 添加选中的参数，显示到paramView并请求数据
            for (YLConditionParamModel *model in priceModels) {
                if (model.isSelect) {
                    [self removeContainParamModel:model];
                    [self.selectParams addObject:model];
                }
            }
            [self showConditionParamView];
        };
        customPrice.surePriceBlock = ^(NSString *lowPrice, NSString *highPrice) {
            // 查询的最高价和最低价
            if ([lowPrice isEqualToString:@""] && [highPrice isEqualToString:@""]) {
                [NSString showMessage:@"最低价和最高价为空"];
            } else {
                if ([lowPrice isEqualToString:@""]) {
                    lowPrice = @"0";
                }
                if ([highPrice isEqualToString:@""]) {
                    highPrice = @"999";
                }
                
                YLConditionParamModel *model = [[YLConditionParamModel alloc] init];
                model.title = [NSString stringWithFormat:@"%@-%@万", lowPrice, highPrice];
                model.param = [NSString stringWithFormat:@"%ldfgf%ld", [lowPrice integerValue] * 10000, [highPrice integerValue] * 10000];
                model.isSelect = YES;
                model.key = @"price";
                
                [self removeContainParamModel:model];
                [self.selectParams addObject:model];
                [self showConditionParamView];
            }
            weakSelf.linkage.isRest = YES;
            [cover removeFromSuperview];
        };
        [cover addSubview:customPrice];
        self.customPrice = customPrice;
        
    } else {// 筛选
        NSArray *headerTitles = @[@"车型", @"车牌所在地", @"变速箱", @"车龄 (单位:年)", @"行驶里程 (单位:万公里)", @"排量 (单位:升)", @"排放标准", @"颜色", @"座位数", @"燃油类型", @"国别",  @"亮点配置"];
        YLMultiSelectController *mulSelect = [[YLMultiSelectController alloc] init];
        mulSelect.multiSelectModels = self.multiSelects;
        mulSelect.headerTitles = headerTitles;
        mulSelect.restAllConditionBlock = ^(NSArray * _Nonnull multiSelectModels) {
            NSLog(@"重置");
        };
        mulSelect.sureBlock = ^(NSArray * _Nonnull multiSelectModels) {
            NSLog(@"确定");
            // 先判断选中的数组中是否包含有已经取消的条件参数
            NSMutableArray *temps = [NSMutableArray array];
            for (YLConditionParamModel *model in weakSelf.selectParams) {
                if (!model.isSelect) {
                    [temps addObject:model];
                }
            }
            // 移除已经取消的条件参数
            [weakSelf.selectParams removeObjectsInArray:temps];
            
            // 将筛选的条件重新添加到条件数组中
            for (NSInteger i = 0; i < multiSelectModels.count; i++) {
                NSArray *modelArray = multiSelectModels[i];
                for (YLConditionParamModel *model in modelArray) {
                    if (model.isSelect) {
                        // 为防止重复，判断是否已经包含了这个条件
                        if (![weakSelf.selectParams containsObject:model]) {
                            [weakSelf.selectParams addObject:model];
                        }
                    }
                }
            }
            [weakSelf showConditionParamView];
        };
        [self.navigationController pushViewController:mulSelect animated:YES];
    }
}

#pragma mark 数据请求
- (void)loadData {
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:hub];
    hub.detailsLabel.text = @"正在加载中";
    [hub showAnimated:YES];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/detail?method=search", YLCommandUrl];
    __weak typeof(self) weakSelf = self;
    [YLRequest GET:urlString parameters:self.param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
            [weakSelf keyedArchiverObject:responseObject toFile:YLBuyCarPath];
            [weakSelf getLocalData];
            [hub removeFromSuperview];
        } else {
            [hub removeFromSuperview];
            NSLog(@"buyCar:%@", responseObject[@"message"]);
        }
    } failed:nil];
}

- (void)getLocalData {
    [self.data removeAllObjects];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLBuyCarPath];
    NSArray *array = [YLCommandModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
    for (YLCommandModel *model in array) {
        YLCommandCellFrame *cellFrame = [[YLCommandCellFrame alloc] init];
        cellFrame.model = model;
        cellFrame.isLargeImage = self.isLargeImage;
        [self.data addObject:cellFrame];
    }
    [self.tableView reloadData];
    
    // 当没有相关车辆，展示noneView
    if (self.data.count > 0) {
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

- (void)refreshData {
    [self loadData];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark tableView代理
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
    
    YLCommandCellFrame *cellFrame = self.data[indexPath.row];
    YLDetailViewController *detail = [[YLDetailViewController alloc] init];
    detail.model = cellFrame.model;
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YLCommandCellFrame *cellFrame = self.data[indexPath.row];
    return cellFrame.cellHeight;
}

#pragma mark getter/setter
- (void)setParamModel:(YLConditionParamModel *)paramModel {
    // 清空请求参数，将传来的参数添加到请求参数中，重新获取数据
    NSLog(@"buycarParamModel:%@", paramModel.title);
    
    // 清空原本请求参数，再添加选中的请求参数
    [self.selectParams removeAllObjects];
    if (!paramModel) { // 判断传过来的模型是否为空
        [self showConditionParamView];
        return;
    }
    // 不为空，则添加到选中条件数组中
    [self.selectParams addObject:paramModel];
    [self showConditionParamView];
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (NSMutableArray *)sorts {
    if (!_sorts) {
        _sorts = [NSMutableArray array];
    }
    return _sorts;
}

- (NSMutableArray *)prices {
    if (!_prices) {
        _prices = [NSMutableArray array];
    }
    return _prices;
}

- (NSMutableArray *)multiSelects {
    if (!_multiSelects) {
        _multiSelects = [NSMutableArray array];
    }
    return _multiSelects;
}

- (NSMutableDictionary *)param {
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}

- (NSMutableArray *)selectParams {
    if (!_selectParams) {
        _selectParams = [NSMutableArray array];
    }
    return _selectParams;
}

@end
