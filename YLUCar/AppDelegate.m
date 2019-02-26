//
//  AppDelegate.m
//  YLUCar
//
//  Created by lm on 2019/1/28.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "AppDelegate.h"
#import "YLTabBarController.h"
#import "YLHomeController.h"
#import "YLBuyCarController.h"
#import "YLSaleCarController.h"
#import "YLMineController.h"
#import "YLNavigationController.h"
#import "YLRequest.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import "YLAccount.h"
#import "YLAccountTool.h"

@interface AppDelegate ()

@property (nonatomic, strong) YLTabBarController *tabBarVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // 检测版本更新
    [self checkVersion];
    [self addUmen];
    [NSThread sleepForTimeInterval:3];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    YLTabBarController *tabBarVC = [[YLTabBarController alloc] init];
    self.tabBarVC = tabBarVC;
    // 首页
    YLHomeController *home = [[YLHomeController alloc] init];
    [self addChildViewController:home title:@"首页" image:@"首页" selectImage:@"首页"];
    // 买车
    YLBuyCarController *buyCar = [[YLBuyCarController alloc] init];
    [self addChildViewController:buyCar title:@"买车" image:@"买车" selectImage:@"买车"];
    // 卖车
    YLSaleCarController *saleCar = [[YLSaleCarController alloc] init];
    [self addChildViewController:saleCar title:@"卖车" image:@"卖车" selectImage:@"卖车"];
    // 我的
    YLMineController *mine = [[YLMineController alloc] init];
    [self addChildViewController:mine title:@"我的" image:@"我的" selectImage:@"我的"];
    
    self.window.rootViewController = tabBarVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)addUmen {
    [UMConfigure setLogEnabled:NO];// 测试日志：console打印,上线必须设置为NO
    [UMConfigure setEncryptEnabled:NO]; // 打开加密传输
    [UMConfigure initWithAppkey:Umengkey channel:@"App Store"]; // 初始化友盟所有组件
    [MobClick setCrashReportEnabled:YES]; // 错误收集

    YLAccount *account = [YLAccountTool account];
    [MobClick profileSignInWithPUID:account.telephone];// 统计用户
    [MobClick profileSignOff];
}

- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage {
    
    childController.title = title;
    childController.tabBarItem.image = [UIImage imageNamed:image];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置自控制器背景
    childController.view.backgroundColor = [UIColor whiteColor];
    childController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);
    
    YLNavigationController *nav = [[YLNavigationController alloc] init];
    [nav addChildViewController:childController];
    [self.tabBarVC addChildViewController:nav];
    
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                       [UIColor blackColor], UITextAttributeTextColor,
//                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = YLColor(23.f, 171.f, 252.f);
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
}

- (void)checkVersion {
    NSString *urlString = [NSString stringWithFormat:@"%@/version?method=ucarIOS", YLCommandUrl];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            NSString *version = responseObject[@"data"][@"versionInfo"];
            // 获取当前工程项目版本号
            NSString *versionString = @"CFBundleShortVersionString";
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = infoDict[versionString];
            NSLog(@"当前版本号:%@/商店版本号:%@", currentVersion, version);
            if ([currentVersion floatValue] < [version floatValue]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                               message:@"检测到新版本,是否更新"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            NSLog(@"点击取消");
                                                        }]];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"更新"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            NSLog(@"点击确定");
                                                            NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@", appleID];
                                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                                                        }]];
                
                [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
            } else {
                NSLog(@"检测到不需要更新");
            }
        }
    } failed:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
