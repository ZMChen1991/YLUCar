//
//  YLMineController.m
//  YLUCar
//
//  Created by lm on 2019/2/13.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLMineController.h"
#import "YLMineHeaderView.h"
#import "YLLoginController.h"
#import "YLAccount.h"
#import "YLAccountTool.h"
#import "YLFunctionView.h"
#import "YLSuggestionController.h"
#import "YLComplaintController.h"
#import "YLSettingController.h"
#import "YLRequest.h"
#import "YLCommandController.h"
#import "YLLookCarSellingController.h"
#import "YLLookCarSoldOutController.h"
#import "YLCollectionsellingController.h"
#import "YLCollectionSoldOutController.h"
#import "YLBrowseHistoryController.h"
#import "YLDepreciateController.h"
#import "YLAllBuyOrderController.h"
#import "YLRecheckBuyOrderController.h"
#import "YLDealBuyOrderController.h"
#import "YLCancelBuyOrderController.h"
#import "YLAllSellOrderController.h"
#import "YLStayOnSellOrderController.h"
#import "YLSellingSellOrderController.h"
#import "YLSaleDoneSellOrderController.h"
#import "YLSoldOutSellOrderController.h"
#import "YLBuyBargainHistoryController.h"
#import "YLSellBargainHistoryController.h"
#import "YLSubscribeController.h"

#define YLMineNumberPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"number.txt"]

@interface YLMineController () <YLMineHeaderViewDelegate, YLFunctionViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) YLMineHeaderView *mineHeader;
@property (nonatomic, strong) YLFunctionView *functionView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arr;

@property (nonatomic, strong) NSString *lastTime;// 上次查看降价提醒的时间

@end

@implementation YLMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arr = @[@"投诉检测中心", @"客服热线", @"意见反馈"];
    [self createView];
    [self setNavigationItem];
    [self addNotification];
    [self refreshTableView];
    [self loadData];
}

- (void)createView {
    CGRect rect = CGRectMake(0, 0, YLScreenWidth, 96);
    YLMineHeaderView *mineHeader = [[YLMineHeaderView alloc] initWithFrame:rect];
    mineHeader.delegate = self;
    [self.view addSubview:mineHeader];
    self.mineHeader = mineHeader;
    
    CGRect funcRect = CGRectMake(0, CGRectGetMaxY(mineHeader.frame), YLScreenWidth, 88 * 2);
    YLFunctionView *functionView = [[YLFunctionView alloc] initWithFrame:funcRect];
    functionView.delegate = self;
    [self.view addSubview:functionView];
    self.functionView = functionView;
    
    CGRect tableViewRect = CGRectMake(0, CGRectGetMaxY(functionView.frame), YLScreenWidth, YLScreenHeight - CGRectGetMaxY(functionView.frame));
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableViewRect];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
}

- (void)loadData {
    [self getLastTime];
    NSLog(@"lastTime:%@", self.lastTime);
    YLAccount *account = [YLAccountTool account];
    if (account) {
        NSString *urlString = [NSString stringWithFormat:@"%@/home?method=num", YLCommandUrl];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        if (!self.lastTime) {
            self.lastTime = [self getcurrendDate:[NSDate date]];
        }
        [param setObject:self.lastTime forKey:@"lastTime"];
        [param setObject:account.telephone forKey:@"telephone"];
        [param setObject:[self getcurrendDate:[NSDate date]] forKey:@"nowTime"];
        __weak typeof(self) weakSelf = self;
        [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
            if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
                [weakSelf keyedArchiverObject:responseObject toFile:YLMineNumberPath];
                [weakSelf getLocalData];
            }
        } failed:nil];
    }
}

- (void)getLocalData {
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLMineNumberPath];
    NSString *book = [dict[@"data"] valueForKey:@"book"];// 即将看车
    NSString *collection = [dict[@"data"] valueForKey:@"collection"];// 收藏
    NSString *subscribe = [dict[@"data"] valueForKey:@"subscribe"];// 订阅
    NSString *reduceNumber = [NSString stringWithFormat:@"%@", [dict[@"data"] valueForKey:@"reduce"]];// 降价
    NSString *bargainNumber = [NSString stringWithFormat:@"%@", [dict[@"data"] valueForKey:@"bargain"]];// 砍价
    if (!book) {
        book = @"0";
    }
    if (!collection) {
        collection = @"0";
    }
    if (!subscribe) {
        subscribe = @"0";
    }
    NSArray *numbers = @[book, collection, [self getBrowseHistoryCount], subscribe];
    self.functionView.numbers = numbers;
    self.functionView.depreciateNumber = reduceNumber;
    self.functionView.bargainNumber = bargainNumber;
}

- (NSString *)getBrowseHistoryCount {
    NSArray *browseHistorys = [NSKeyedUnarchiver unarchiveObjectWithFile:YLBrowsingHistoryPath];
    NSString *browseCount;
    if (!browseHistorys) {
        browseCount = @"0";
    } else {
        browseCount = [NSString stringWithFormat:@"%ld", browseHistorys.count];
    }
    return browseCount;
}

- (void)keyedArchiverObject:(id)obj toFile:(NSString *)filePath {
    BOOL success = [NSKeyedArchiver archiveRootObject:obj toFile:filePath];
    if (success) {
        NSLog(@"数据保存成功");
    } else {
        NSLog(@"保存失败");
    }
}


#pragma mark tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"Cell";
    // 1.拿到一个标识先去缓存池中查找对应的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 2.如果缓存池中没有，才需要传入一个标识创新的cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.font = YLFont(14);
    cell.textLabel.text = self.arr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        NSLog(@"投诉检测中心");
        [self complaintDetectionCenter];
    } else if (indexPath.row == 1) {
        NSLog(@"客服热线");
        [self callCustomerServiceHotline];
    } else {
        NSLog(@"意见反馈");
        [self suggestions];
    }
}

// 投诉检测中心
- (void)complaintDetectionCenter {
    YLComplaintController *complaint = [[YLComplaintController alloc] init];
    [self.navigationController pushViewController:complaint animated:YES];
}

// 意见反馈
- (void)suggestions {
    YLSuggestionController *suggestion = [[YLSuggestionController alloc] init];
    [self.navigationController pushViewController:suggestion animated:YES];
}

// 客服热线
- (void)callCustomerServiceHotline {
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", customerServicePhone];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}

#pragma mark 其他代理
- (void)numberViewClickAtIndex:(NSInteger)index {
    
    if (index == 2) {
        NSLog(@"浏览记录");
        YLBrowseHistoryController *browseHistory = [[YLBrowseHistoryController alloc] init];
        [self.navigationController pushViewController:browseHistory animated:YES];
    } else {
        YLAccount *account = [YLAccountTool account];
        if (account) {
            if (index == 0) {
                NSLog(@"即将看车");
                NSArray *titles = @[@"在售", @"下架"];
                YLLookCarSellingController *sell = [[YLLookCarSellingController alloc] init];
                YLLookCarSoldOutController *soldOut = [[YLLookCarSoldOutController alloc] init];
                YLCommandController *lookCar = [[YLCommandController alloc] init];
                lookCar.titles= titles;
                lookCar.title = @"即将看车";
                lookCar.controllers = @[sell, soldOut];
                [self.navigationController pushViewController:lookCar animated:YES];
                
            } else if (index == 1) {
                NSLog(@"我的收藏");
                NSArray *titles = @[@"在售", @"下架"];
                YLCollectionsellingController *sell = [[YLCollectionsellingController alloc] init];
                YLCollectionSoldOutController *soldOut = [[YLCollectionSoldOutController alloc] init];
                YLCommandController *collectCar = [[YLCommandController alloc] init];
                collectCar.titles= titles;
                collectCar.title = @"我的收藏";
                collectCar.controllers = @[sell, soldOut];
                [self.navigationController pushViewController:collectCar animated:YES];
                
            } else {
                NSLog(@"我的订阅");
                YLSubscribeController *subscribe = [[YLSubscribeController alloc] init];
                subscribe.title = @"我的订阅";
                [self.navigationController pushViewController:subscribe animated:YES];
            }
        } else {
            [self skipLoginController];
        }
    }
}

- (void)customBtnClickAtIndex:(NSInteger)index {
    
    YLAccount *account = [YLAccountTool account];
    if (account) {
        if (index == 0) {
            NSLog(@"买车订单");
            NSArray *titles = @[@"全部", @"待复检过户", @"交易完成", @"交易取消"];
            YLAllBuyOrderController *all = [[YLAllBuyOrderController alloc] init];
            YLRecheckBuyOrderController *recheck = [[YLRecheckBuyOrderController alloc] init];
            YLDealBuyOrderController *deal = [[YLDealBuyOrderController alloc] init];
            YLCancelBuyOrderController *cancel = [[YLCancelBuyOrderController alloc] init];
            YLCommandController *buyCar = [[YLCommandController alloc] init];
            buyCar.titles= titles;
            buyCar.title = @"买车订单";
            buyCar.controllers = @[all, recheck, deal, cancel];
            [self.navigationController pushViewController:buyCar animated:YES];
        } else if (index == 1) {
            NSLog(@"卖车订单");
            NSArray *titles = @[@"全部", @"待上架",@"售卖中", @"已售出",@"已下架"];
            YLAllSellOrderController *all = [[YLAllSellOrderController alloc] init];
            YLStayOnSellOrderController *stayOn = [[YLStayOnSellOrderController alloc] init];
            YLSellingSellOrderController *selling = [[YLSellingSellOrderController alloc] init];
            YLSaleDoneSellOrderController *saleDone = [[YLSaleDoneSellOrderController alloc] init];
            YLSoldOutSellOrderController *soldOut = [[YLSoldOutSellOrderController alloc] init];
            YLCommandController *sellCar = [[YLCommandController alloc] init];
            sellCar.titles= titles;
            sellCar.title = @"卖车订单";
            sellCar.controllers = @[all, stayOn, selling, saleDone, soldOut];
            [self.navigationController pushViewController:sellCar animated:YES];
        } else if (index == 2) {
            NSLog(@"砍价记录");
            NSArray *titles = @[@"买家", @"卖家"];
            YLBuyBargainHistoryController *buy = [[YLBuyBargainHistoryController alloc] init];
            YLSellBargainHistoryController *sell = [[YLSellBargainHistoryController alloc] init];
            YLCommandController *bargain = [[YLCommandController alloc] init];
            bargain.titles= titles;
            bargain.title = @"砍价记录";
            bargain.controllers = @[buy, sell];
            [self.navigationController pushViewController:bargain animated:YES];
        } else {
            NSLog(@"降价提醒");
            // 保存当前打开降价提醒的时间
            [self saveLastTime];
            YLDepreciateController *depreciate = [[YLDepreciateController alloc] init];
            [self.navigationController pushViewController:depreciate animated:YES];
        }
    } else {
        [self skipLoginController];
    }
}

#pragma mark config
- (void)setNavigationItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
}

- (void)rightBarButtonItemClick {

    YLSettingController *setting = [[YLSettingController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];   
}

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:REFRESHMINEVIEW object:nil];
}

- (void)refreshTableView {
    NSLog(@"通知更新数据");
    YLAccount *account = [YLAccountTool account];
    if (account) {
        self.mineHeader.type = YLMineHeaderViewTypeLogin;
        self.mineHeader.telephone = account.telephone;
        // 重新加载数据
        [self loadData];
    } else {
        self.mineHeader.type = YLMineHeaderViewTypeLogout;
        // 赋值
        NSMutableArray *numbers = [NSMutableArray arrayWithObjects:@"0", @"0", [self getBrowseHistoryCount], @"0", nil];
        self.functionView.numbers = numbers;
    }
}

- (void)skipLoginController {
    NSLog(@"跳转到登录控制器");
    __weak typeof(self) weakSelf = self;
    YLLoginController *login = [[YLLoginController alloc] init];
    login.loginBlock = ^(NSString * _Nonnull telephone) {
        [weakSelf refreshTableView];
    };
    [self.navigationController pushViewController:login animated:YES];
}

- (NSString *)getcurrendDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

- (void)saveLastTime {
    self.lastTime = [self getcurrendDate:[NSDate date]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.lastTime forKey:@"lastTime"];
    [defaults synchronize];
}

- (void)getLastTime {
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    self.lastTime = [defaluts objectForKey:@"lastTime"];
}

//- (NSDate *)lastTime {
//    if (!_lastTime) {
//        NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
//        _lastTime = [defaluts objectForKey:@"lastTime"];
//        if (!_lastTime) {
//            _lastTime = [NSDate date];
//        }
//    }
//    return _lastTime;
//}

@end
