//
//  YLBuyOrderDetailController.m
//  YLUCar
//
//  Created by lm on 2019/2/20.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLBuyOrderDetailController.h"
#import "YLCommandView.h"
#import "YLCommandViewFrame.h"
#import "YLContactView.h"
#import "YLBuyOrderModel.h"
#import "YLCommandModel.h"
#import "YLDetailViewController.h"

@interface YLBuyOrderDetailController () <YlContactViewDelegate>

//@property (nonatomic, strong) YLCommandView *commandView;
//@property (nonatomic, strong) YLContactView *contactView;

@end

@implementation YLBuyOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"订单详情";
    [self.view setUserInteractionEnabled:YES];
    
    [self createView];
}

- (void)createView {
    
    YLCommandModel *commandModel = [YLCommandModel mj_objectWithKeyValues:self.model.detail];
    YLCommandViewFrame *viewFrame = [[YLCommandViewFrame alloc] init];
    viewFrame.model = commandModel;
    CGRect rect = CGRectMake(0, 0, YLScreenWidth, viewFrame.viewHeight);
    YLCommandView *commandView = [[YLCommandView alloc] initWithFrame:rect];
    commandView.viewFrame = viewFrame;
    [self.view addSubview:commandView];
    
    commandView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commandViewClick)];
    [commandView addGestureRecognizer:tap];
    
    YLContactView *contact = [[YLContactView alloc] init];
    contact.frame = CGRectMake(0, viewFrame.viewHeight, YLScreenWidth, YLScreenHeight - viewFrame.viewHeight);
    contact.delegate = self;
    contact.model = self.model;
    [self.view addSubview:contact];
}


- (void)commandViewClick {
    NSLog(@"clickCommandView");
    YLCommandModel *commandModel = [YLCommandModel mj_objectWithKeyValues:self.model.detail];
    YLDetailViewController *detail = [[YLDetailViewController alloc] init];
    detail.model = commandModel;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark 代理
- (void)contactCustomer {
    NSLog(@"联系客服");
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", customerServicePhone];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}

- (void)setModel:(YLBuyOrderModel *)model {
    _model = model;
}

@end
