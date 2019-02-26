//
//  YLLookCarDetailController.m
//  YLUCar
//
//  Created by lm on 2019/2/22.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLLookCarDetailController.h"
#import "YLCommandModel.h"
#import "YLCommandViewFrame.h"
#import "YLCommandView.h"
#import "YLLookCarModel.h"
#import "YLDetailViewController.h"
#import "YLRequest.h"
#import "YLDetectCenterModel.h"
#import "YLLookCarDetailView.h"

#define YLCenterPath(centerId) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:centerId]

@interface YLLookCarDetailController ()

@property (nonatomic, strong) YLDetectCenterModel *centerModel;

@property (nonatomic, strong) YLCommandView *commandView;
@property (nonatomic, strong) YLLookCarDetailView *lookCarDetailView;

@end

@implementation YLLookCarDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createView];
    
    [self getLocationData];
    [self loadData];
}

- (void)createView {
    YLCommandModel *commandModel = [YLCommandModel mj_objectWithKeyValues:self.model.detail];
    YLCommandViewFrame *viewFrame = [[YLCommandViewFrame alloc] init];
    viewFrame.model = commandModel;
    CGRect rect = CGRectMake(0, 0, YLScreenWidth, viewFrame.viewHeight);
    YLCommandView *commandView = [[YLCommandView alloc] initWithFrame:rect];
    commandView.viewFrame = viewFrame;
    commandView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commandViewClick)];
    [commandView addGestureRecognizer:tap];
    [self.view addSubview:commandView];
    self.commandView = commandView;

    CGFloat viewH = 163 + 2 * LeftMargin;
    CGRect viewRect = CGRectMake(LeftMargin, viewFrame.viewHeight + 2 * LeftMargin, YLScreenWidth - 2 * LeftMargin, viewH);
    YLLookCarDetailView *lookCarDetailView = [[YLLookCarDetailView alloc] initWithFrame:viewRect];
    [self.view addSubview:lookCarDetailView];
    self.lookCarDetailView = lookCarDetailView;
}

- (void)commandViewClick {
    YLCommandModel *commandModel = [YLCommandModel mj_objectWithKeyValues:self.model.detail];
    YLDetailViewController *detai = [[YLDetailViewController alloc] init];
    detai.model = commandModel;
    [self.navigationController pushViewController:detai animated:YES];
}

- (void)loadData {
    // 根据检测中心ID获取检测中心的信息
    NSString *urlString = [NSString stringWithFormat:@"%@/center?method=id", YLCommandUrl];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.model.centerId forKey:@"id"];
    __weak typeof(self) weakSelf = self;
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            [weakSelf keyedArchiverObject:responseObject toFile:YLCenterPath(weakSelf.model.centerId)];
            [weakSelf getLocationData];
        } else {
            [NSString showMessage:[NSString stringWithFormat:@"%@", responseObject[@"message"]]];
        }
    } failed:nil];
}

- (void)getLocationData {
    
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLCenterPath(self.model.centerId)];
    if (!dict) {
        return;
    }
    self.centerModel = [YLDetectCenterModel mj_objectWithKeyValues:dict[@"data"]];
    self.lookCarDetailView.appointTime = self.model.appointTime;
    self.lookCarDetailView.model = self.centerModel;
}

- (void)keyedArchiverObject:(id)obj toFile:(NSString *)filePath {
    BOOL success = [NSKeyedArchiver archiveRootObject:obj toFile:filePath];
    if (success) {
        NSLog(@"首页数据保存成功");
    } else {
        NSLog(@"保存失败");
    }
}

@end
