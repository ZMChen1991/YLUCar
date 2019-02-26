//
//  YLSearchCarController.m
//  YLUCar
//
//  Created by lm on 2019/2/25.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLSearchCarController.h"
#import "YLNavigationController.h"
#import "YLTabBarController.h"
#import "YLBuyCarController.h"
#import "YLConditionParamModel.h"
#import "YLSearchBar.h"
#import "YLRequest.h"
#import "YLSearchHistoryView.h"

#define YLSearchKeyWordPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"keyWord.txt"]

@interface YLSearchCarController () <YLSearchHistoryViewDelegate>

@property (nonatomic, strong) YLSearchBar *searchBar;

@property (nonatomic, strong) YLSearchHistoryView *searchHistoryView;
@property (nonatomic, strong) YLSearchHistoryView *hotSearchView;

@property (nonatomic, strong) NSMutableArray *searchHistorys;
@property (nonatomic, strong) NSMutableArray *hotSearchs;

@end

@implementation YLSearchCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNav];
    [self createView];
    
    [self getLocalData];
    [self loadData];
}

- (void)setNav {
    
    // 添加搜索框视图
    CGFloat viewH = 44;
    CGFloat viewW = 230;
    CGFloat searchBarH = 36;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
    YLSearchBar *searchBar = [YLSearchBar searchBar];
    searchBar.frame = CGRectMake(0, (viewH - searchBarH) / 2, viewW, searchBarH);
    [searchBar setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [view addSubview:searchBar];
    self.navigationItem.titleView = view;
    self.searchBar = searchBar;
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem = rightBar;
    // 修改rightBarButtonItem颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // 修改rightBarButtonItem字体
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:YLFont(16), NSFontAttributeName, nil] forState:UIControlStateNormal];
}

- (void)createView {
    
    YLSearchHistoryView *searchView = [[YLSearchHistoryView alloc] init];
    searchView.frame = CGRectMake(0, 0, YLScreenWidth, searchView.viewHeight);
    searchView.isHideDelete = YES;
    searchView.title = @"热门搜索";
    searchView.delegate = self;
    [self.view addSubview:searchView];
    self.hotSearchView = searchView;
    
    YLSearchHistoryView *historyView = [[YLSearchHistoryView alloc] init];
    historyView.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame) + TopMargin, YLScreenWidth, 300);
    historyView.isHideDelete = NO;
    historyView.title = @"历史搜索";
    historyView.delegate = self;
    [self.view addSubview:historyView];
    self.searchHistoryView = historyView;
}

#pragma mark 代理
- (void)searchTitle:(NSString *)searchTitle {
    [self saveSearcHistorywithTitle:searchTitle];
    self.searchHistoryView.searchHistory = self.searchHistorys;
    [self pushBuyCarControllerWithTitle:searchTitle];
}

- (void)clearSearchHistory {
    // 清空
    [self.searchHistorys removeAllObjects];
    [self keyedArchiverObject:self.searchHistorys toFile:YLSearchHistoryPath];
}

- (void)search {
    NSLog(@"点击搜索");
    // 点击搜索，保存搜索记录并跳转到买车页面搜索
    NSString *searchTitle = self.searchBar.text;
    
    if ([NSString isBlankString:searchTitle]) {
        [NSString showMessage:@"请输入您想要搜索的车"];
    } else {
        [self saveSearcHistorywithTitle:searchTitle];
        self.searchHistoryView.searchHistory = self.searchHistorys;
        [self pushBuyCarControllerWithTitle:searchTitle];
    }
}

- (void)saveSearcHistorywithTitle:(NSString *)title {
    
    self.searchBar.text = @"";
    
    // 判断历史记录里面是否已经包含
    if ([self.searchHistorys containsObject:title]) {
        NSInteger index = [self.searchHistorys indexOfObject:title];
        [self.searchHistorys removeObjectAtIndex:index];
    }
    // 在头部插入
    [self.searchHistorys insertObject:title atIndex:0];
    // 判断历史记录个数是否大于6
    if (self.searchHistorys.count > 6) {
        [self.searchHistorys removeLastObject];
    }
    // 保存到本地
    [self keyedArchiverObject:self.searchHistorys toFile:YLSearchHistoryPath];
}

- (void)pushBuyCarControllerWithTitle:(NSString *)title {
    
    YLConditionParamModel *model = [[YLConditionParamModel alloc] init];
    model.title = title;
    model.param = title;
    model.key = @"title";
    model.detailTitle = title;
    
    YLTabBarController *tab = (YLTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    YLNavigationController *nav = tab.viewControllers[1];
    YLBuyCarController *buy = nav.viewControllers.firstObject;
    buy.paramModel = model;
    tab.selectedIndex = 1;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData {
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:hub];
    hub.detailsLabel.text = @"正在加载中";
    [hub showAnimated:YES];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/home?method=keyword", YLCommandUrl];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            [weakSelf keyedArchiverObject:responseObject toFile:YLSearchKeyWordPath];
            [weakSelf getLocalData];
            [hub removeFromSuperview];
        } else {
            [hub removeFromSuperview];
            [NSString showMessage:[NSString stringWithFormat:@"%@", responseObject[@"message"]]];
        }
    } failed:nil];
}

- (void)getLocalData {
    
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLSearchKeyWordPath];
    NSArray *keyWords = dict[@"data"][@"keyword"];
    self.hotSearchView.searchHistory = [NSMutableArray arrayWithArray:keyWords];
    self.searchHistoryView.searchHistory = self.searchHistorys;
}

- (void)keyedArchiverObject:(id)obj toFile:(NSString *)filePath {
    BOOL success = [NSKeyedArchiver archiveRootObject:obj toFile:filePath];
    if (success) {
        NSLog(@"数据保存成功");
    } else {
        NSLog(@"保存失败");
    }
}

- (NSMutableArray *)searchHistorys {
    if (!_searchHistorys) {
        _searchHistorys = [NSKeyedUnarchiver unarchiveObjectWithFile:YLSearchHistoryPath];
        if (!_searchHistorys) {
            _searchHistorys = [NSMutableArray array];
        }
    }
    return _searchHistorys;
}

@end
