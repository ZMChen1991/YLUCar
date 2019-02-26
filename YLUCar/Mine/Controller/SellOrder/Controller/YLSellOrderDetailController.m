//
//  YLSellOrderDetailController.m
//  YLUCar
//
//  Created by lm on 2019/2/20.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLSellOrderDetailController.h"
#import "YLSaleOrderModel.h"
#import "YLRequest.h"
#import "YLSellOrderDetailView.h"
#import "YLCommandModel.h"
#import "YLDetailViewController.h"
#import "YLSaleOrderChangePriceView.h"
#import "YLAccepBargainPriceView.h"

#define YLSellOrderDetailPath(carID) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"SellOrderDetail-%@", carID]]

@interface YLSellOrderDetailController () <YLSellOrderDetailViewDelegate, YLSaleOrderChangePriceViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) YLSellOrderDetailView *detailView;
@property (nonatomic, strong) YLSaleOrderChangePriceView *changePriceView;
//@property (nonatomic, strong) YLAccepBargainPriceView *soldOut;
//@property (nonatomic, strong) YLAccepBargainPriceView *putaway;
@property (nonatomic, strong) UIView *cover;

@property (nonatomic, strong) YLSaleOrderModel *detailModel;

@end

@implementation YLSellOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"订单详情";
    
    [self setupNav];
    [self createView];
    [self getLocalData];
    [self loadData];
}

- (void)setupNav {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
}

- (void)rightBarButtonItemClick {
    [self loadData];
}

- (void)createView {
    CGRect rect = CGRectMake(0, 0, YLScreenWidth, YLScreenHeight);
    YLSellOrderDetailView *detailView = [[YLSellOrderDetailView alloc] initWithFrame:rect];
    detailView.delegate = self;
    [self.view addSubview:detailView];
    self.detailView = detailView;
}


- (void)loadData {
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:hub];
    hub.detailsLabel.text = @"正在加载中";
    [hub showAnimated:YES];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/sell?method=record", YLCommandUrl];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.model.detail.carID forKey:@"detailId"];
    __weak typeof(self) weakSelf = self;
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            [weakSelf keyedArchiverObject:responseObject toFile:YLSellOrderDetailPath(weakSelf.model.detail.carID)];
            [weakSelf getLocalData];
            [hub removeFromSuperview];
        } else {
            [hub removeFromSuperview];
            [NSString showMessage:[NSString stringWithFormat:@"%@", responseObject[@"message"]]];
        }
    } failed:nil];
}

- (void)getLocalData {
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLSellOrderDetailPath(self.model.detail.carID)];
    YLSaleOrderModel *model = [YLSaleOrderModel mj_objectWithKeyValues:dict[@"data"]];
    self.detailView.model = model;
    self.detailModel = model;
}

- (void)keyedArchiverObject:(id)obj toFile:(NSString *)filePath {
    BOOL success = [NSKeyedArchiver archiveRootObject:obj toFile:filePath];
    if (success) {
        NSLog(@"即将看车下架数据保存成功");
    } else {
        NSLog(@"保存失败");
    }
}


#pragma mark 代理
- (void)checkCarDetail {
    // 跳转详情页
    YLCommandModel *model = [YLCommandModel mj_objectWithKeyValues:self.model.detail];
    YLDetailViewController *detail = [[YLDetailViewController alloc] init];
    detail.model = model;
    [self.navigationController pushViewController:detail animated:YES];
}

// 重新上架
- (void)sellOrderDetailPutaway {
    NSLog(@"车辆上架");
    
//    [self addCoverView];
//
//    CGFloat viewH = 105;
//    CGFloat viewY = (YLScreenHeight - viewH) / 2;
//    CGFloat viewW =YLScreenWidth - 2 * LeftMargin;
//    CGRect rect = CGRectMake(LeftMargin, viewY, viewW, viewH);
//    YLAccepBargainPriceView *putaway = [[YLAccepBargainPriceView alloc] initWithFrame:rect];
//    putaway.delegate = self;
//    putaway.title = @"确定上架车辆";
//    [self.cover addSubview:putaway];
//    self.putaway = putaway;
    
    [self surePutaway];
}

- (void)surePutaway {
    
    [self.cover removeFromSuperview];
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:hub];
    hub.detailsLabel.text = @"正在加载中";
    [hub showAnimated:YES];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/sell?method=handle", YLCommandUrl];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.model.detail.carID forKey:@"detailId"];
    [param setObject:@"3" forKey:@"status"];// 上架状态是3
    __weak typeof(self) weakSelf = self;
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            [weakSelf loadData];
            [hub removeFromSuperview];
            [NSString showMessage:@"上架成功"];
        } else {
            [hub removeFromSuperview];
            [NSString showMessage:[NSString stringWithFormat:@"%@", responseObject[@"message"]]];
        }
    } failed:nil];
}

// 车辆下架
- (void)sellOrderDetailSoldOut {
    NSLog(@"车辆下架");
    
//    [self addCoverView];
//
//    CGFloat viewH = 105;
//    CGFloat viewY = (YLScreenHeight - viewH) / 2;
//    CGFloat viewW =YLScreenWidth - 2 * LeftMargin;
//    CGRect rect = CGRectMake(LeftMargin, viewY, viewW, viewH);
//    YLAccepBargainPriceView *soldOut = [[YLAccepBargainPriceView alloc] initWithFrame:rect];
//    soldOut.delegate = self;
//    soldOut.title = @"确定下架车辆";
//    [self.cover addSubview:soldOut];
//    self.soldOut = soldOut;
    
    [self sureSoldOut];
}

- (void)sureSoldOut {
    
    [self.cover removeFromSuperview];
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:hub];
    hub.detailsLabel.text = @"正在加载中";
    [hub showAnimated:YES];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/sell?method=handle", YLCommandUrl];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.model.detail.carID forKey:@"detailId"];
    [param setObject:@"0" forKey:@"status"];// 下架状态是0
    __weak typeof(self) weakSelf = self;
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            [weakSelf loadData];
            [hub removeFromSuperview];
            [NSString showMessage:@"车辆下架成功"];
        } else {
            [hub removeFromSuperview];
            [NSString showMessage:[NSString stringWithFormat:@"%@", responseObject[@"message"]]];
        }
    } failed:nil];
}

// 修改价格
- (void)sellOrderDetailChangePrice {
    
    NSLog(@"修改价格");
    [self addCoverView];
    
    // 显示修改价格视图
    CGFloat viewH = 210;
    CGFloat viewW = YLScreenWidth - 2 * LeftMargin;
    CGFloat viewY = (YLScreenHeight - viewH) / 2;
    CGRect rect = CGRectMake(LeftMargin, viewY, viewW, viewH);
    YLSaleOrderChangePriceView *changePriceView = [[YLSaleOrderChangePriceView alloc] initWithFrame:rect];
    changePriceView.delegate = self;
    [self.cover addSubview:changePriceView];
    self.changePriceView = changePriceView;
}

- (void)cancelChangePrice {
    [self.cover removeFromSuperview];
}

- (void)sureWithPrice:(NSString *)price floorPrice:(NSString *)floorPrice isAccept:(BOOL)isAccept {
    
    // 发送修改价格请求
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:hub];
    hub.detailsLabel.text = @"正在加载中";
    [hub showAnimated:YES];
    
    [self.cover removeFromSuperview];
//    NSLog(@"%@-%@-%d", price, floorPrice, isAccept);
    NSString *priceNumber = [NSString stringWithFormat:@"%ld", [price integerValue] * 10000];
    NSString *floorPriceNumber = [NSString stringWithFormat:@"%ld", [floorPrice integerValue] * 10000];
    
    // 向后台发送修改价格请求
    NSString *urlString = [NSString stringWithFormat:@"%@/sell?method=change", YLCommandUrl];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.detailModel.detail.carID forKey:@"detailId"];
    [param setValue:self.detailModel.detail.price forKey:@"prePrice"];
    [param setValue:priceNumber forKey:@"price"];
    [param setValue:floorPriceNumber forKey:@"floorPrice"];
    [param setValue:[NSNumber numberWithBool:isAccept] forKey:@"isBargain"];
    __weak typeof(self) weakSelf = self;
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            [weakSelf loadData];
            [hub removeFromSuperview];
            [NSString showMessage:@"价格修改成功"];
        } else {
            [hub removeFromSuperview];
            [NSString showMessage:[NSString stringWithFormat:@"%@", responseObject[@"message"]]];
        }
    } failed:nil];
}

- (void)cancelAccept {
    [self.cover removeFromSuperview];
}

- (void)addCoverView {
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    UIView *cover = [[UIView alloc] initWithFrame:window.bounds];
    cover.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3];
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    tap.delegate = self;
    [cover addGestureRecognizer:tap];
    
    [window addSubview:cover];
    self.cover = cover;
}

- (void)tapClick:(UITapGestureRecognizer *)sender {
    [sender.view removeFromSuperview];
}

// 排除子视图响应手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.changePriceView]) {
        return NO;
    }
    return YES;
}

@end
