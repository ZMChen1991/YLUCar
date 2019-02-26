//
//  YLDetectCenterController.m
//  YLUCar
//
//  Created by lm on 2019/2/14.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLDetectCenterController.h"
#import "YLDetectCenterModel.h"
#import "YLDetectCenterCellFrame.h"
#import "YLDetectCenterCell.h"
#import "YLRequest.h"

#define YLDetectCenterPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"DetectCenter.txt"]

@interface YLDetectCenterController ()

@property (nonatomic, strong) NSMutableArray *detectCenters;

@end

@implementation YLDetectCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"检测中心";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getLocationData];
    [self loadData];
}

- (void)loadData {
    NSString *urlString = [NSString stringWithFormat:@"%@/center?method=city", YLCommandUrl];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.city forKey:@"city"];
    // 获取检测中心数据
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
            NSLog(@"获取检测中心数据成功");
            [self keyedArchiverObject:responseObject toFile:YLDetectCenterPath];
            [self getLocationData];
        } else {
            NSLog(@"%@", responseObject[@"message"]);
            [NSString showMessage:@"获取数据失败,请稍后再试"];
        }
    } failed:nil];
}

- (void)getLocationData {
    
    [self.detectCenters removeAllObjects];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:YLDetectCenterPath];
    NSArray *models = [YLDetectCenterModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
    for (YLDetectCenterModel *model in models) {
        YLDetectCenterCellFrame *cellFrame = [[YLDetectCenterCellFrame alloc] init];
        cellFrame.model = model;
        [self.detectCenters addObject:cellFrame];
    }
    [self.tableView reloadData];
}

- (void)keyedArchiverObject:(id)obj toFile:(NSString *)filePath {
    BOOL success = [NSKeyedArchiver archiveRootObject:obj toFile:filePath];
    if (success) {
        NSLog(@"首页数据保存成功");
    } else {
        NSLog(@"保存失败");
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detectCenters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLDetectCenterCell *cell = [YLDetectCenterCell cellWithTableView:tableView];
    YLDetectCenterCellFrame *cellFrame = self.detectCenters[indexPath.row];
    cell.cellFrame = cellFrame;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YLDetectCenterCellFrame *cellFrame = self.detectCenters[indexPath.row];
    return cellFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLDetectCenterCellFrame *cellFrame = self.detectCenters[indexPath.row];
    if (self.detectCenterBlock) {
        self.detectCenterBlock(cellFrame.model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)detectCenters {
    if (!_detectCenters) {
        _detectCenters = [NSMutableArray array];
    }
    return _detectCenters;
}

@end
