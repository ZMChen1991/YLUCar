//
//  YLSuggestionController.m
//  YLUCar
//
//  Created by lm on 2019/2/14.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLSuggestionController.h"
#import "YLCondition.h"
#import "YLAccountTool.h"
#import "YLAccount.h"
#import "YLRequest.h"

@interface YLSuggestionController ()

@property (nonatomic, strong) UITextView *suggestion;
@property (nonatomic, strong) UITextField *telephone;

@end

@implementation YLSuggestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createView];
}

- (void)createView {
    YLAccount *account = [YLAccountTool account];
    
    NSInteger width = YLScreenWidth - 2 * LeftMargin;
    UITextView *suggestion = [[UITextView alloc] initWithFrame:CGRectMake(LeftMargin, LeftMargin , width, 130)];
    suggestion.layer.cornerRadius = 5;
    suggestion.layer.borderWidth = 0.6;
    suggestion.layer.borderColor = YLColor(233.f, 233.f, 233.f).CGColor;
    suggestion.layer.masksToBounds = YES;
    suggestion.font = [UIFont systemFontOfSize:14];
    [suggestion setPlaceholder:@"请输入您的意见或者建议..." placeholdColor:[UIColor grayColor]];
    [self.view addSubview:suggestion];
    self.suggestion = suggestion;
    
    UITextField *telephone = [[UITextField alloc] initWithFrame:CGRectMake(LeftMargin, CGRectGetMaxY(suggestion.frame) + TopMargin, width, 50)];
    telephone.layer.cornerRadius = 5;
    telephone.layer.borderWidth = 0.6;
    telephone.layer.borderColor = YLColor(233.f, 233.f, 233.f).CGColor;
    telephone.layer.masksToBounds = YES;
    telephone.font = [UIFont systemFontOfSize:14];
    telephone.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    telephone.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:telephone];
    self.telephone = telephone;
    if (account) {
        telephone.text = account.telephone;
    } else {
        telephone.placeholder = @"联系方式（选填）";
    }
    
    YLCondition *commitBtn = [[YLCondition alloc] initWithFrame:CGRectMake(LeftMargin, CGRectGetMaxY(telephone.frame) + TopMargin, width, 40)];
    commitBtn.type = YLConditionTypeBlue;
    commitBtn.titleLabel.font = YLFont(14);
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
}

- (void)commit {
    
    [self.view endEditing:YES];
    NSLog(@"提交意见反馈");
    [self postSuggestion];
}

- (void)postSuggestion {
    // 提交意见反馈
    NSString *urlString = [NSString stringWithFormat:@"%@/opinion?method=add", YLCommandUrl];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.telephone.text forKey:@"telephone"];
    [param setValue:self.suggestion.text forKey:@"remarks"];
    [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
            NSLog(@"提交成功!");
            [NSString showMessage:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"提交失败!");
            [NSString showMessage:responseObject[@"message"]];
        }
    } failed:nil];
}

@end
