//
//  YLSettingController.m
//  YLUCar
//
//  Created by lm on 2019/2/15.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLSettingController.h"
#import "YLCondition.h"
#import "YLAccountTool.h"
#import "YLAboutController.h"


@interface YLSettingController ()

@property (nonatomic, strong) NSArray *titles;

@end

@implementation YLSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.titles = @[@"关于优卡"];
    self.tableView.bounces = NO;
    
    [self createView];
}

- (void)createView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, 80)];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = view;
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YLScreenWidth, 1)];
    line.backgroundColor = YLColor(233.f, 233.f, 233.f);
    [view addSubview:line];
    
    YLCondition *logout = [YLCondition buttonWithType:UIButtonTypeCustom];
    logout.type = YLConditionTypeBlue;
    logout.frame = CGRectMake(LeftMargin, LeftMargin, YLScreenWidth - 2 * LeftMargin, 40);
    logout.titleLabel.font = YLFont(14);
    [logout setTitle:@"退出登录" forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:logout];
    
    YLAccount *account = [YLAccountTool account];
    if (account) {
        view.hidden = NO;
    } else {
        view.hidden = YES;
    }
}

- (void)logoutClick {
    
    [YLAccountTool loginOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHMINEVIEW object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

#pragma mark 循环利用cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"Cell";
    // 1.拿到一个标识先去缓存池中查找对应的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 2.如果缓存池中没有，才需要传入一个标识创新的cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = YLFont(14);
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YLAboutController *about = [[YLAboutController alloc] init];
    [self.navigationController pushViewController:about animated:YES];
}

@end
