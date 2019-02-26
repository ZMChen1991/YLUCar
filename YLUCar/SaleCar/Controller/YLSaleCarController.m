//
//  YLSaleCarController.m
//  YLUCar
//
//  Created by lm on 2019/1/28.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLSaleCarController.h"
#import "YLSaleView.h"
#import "YLAccount.h"
#import "YLAccountTool.h"
#import "YLRequest.h"
#import "YLLoginController.h"
#import "YLOrderSaleCarController.h"

#define YLApplyNumberPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ApplyNumber.txt"]

@interface YLSaleCarController ()

@property (nonatomic, strong) YLSaleView *saleView;

@end

@implementation YLSaleCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"YLSaleCarController");
    
    [self createView];
    [self getLocationData];
    [self loadData];
}

- (void)createView {
    
    YLSaleView *saleView = [[YLSaleView alloc] initWithFrame:self.view.bounds];
    __weak typeof(self) weakSelf = self;
    saleView.saleCarBlock = ^{
        [weakSelf saleCar];
    };
    saleView.consultBlock = ^{
        [weakSelf freeConsultation];
    };
    [self.view addSubview:saleView];
    self.saleView = saleView;
}

- (void)saleCar {
    YLAccount *account = [YLAccountTool account];
    if (account) {
        // 跳转预约卖车界面
        YLOrderSaleCarController *orderSaleCar = [[YLOrderSaleCarController alloc] init];
        orderSaleCar.telephone = account.telephone;
        [self.navigationController pushViewController:orderSaleCar animated:YES];
        
    } else {
        __weak typeof(self) weakSelf = self;
        YLLoginController *login = [[YLLoginController alloc] init];
        login.loginBlock = ^(NSString * _Nonnull telephone) {
            [weakSelf getLocationData];
        };
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (void)freeConsultation {
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", customerServicePhone];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}

- (void)loadData {
    NSString *urlString = [NSString stringWithFormat:@"%@/home?method=apply", YLCommandUrl];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            [weakSelf keyedArchiverObject:responseObject toFile:YLApplyNumberPath];
            [weakSelf getLocationData];
        }
    } failed:nil];
}

- (void)getLocationData {
    YLAccount *account = [YLAccountTool account];
    if (account) {
        self.saleView.telephone = account.telephone;
    }
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLApplyNumberPath];
    NSString *apply = [dict[@"data"] valueForKey:@"apply"];
    if (!apply) {
        self.saleView.salerNum = @"0";
    } else {
        self.saleView.salerNum = [NSString stringWithFormat:@"%@", apply];
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
@end
