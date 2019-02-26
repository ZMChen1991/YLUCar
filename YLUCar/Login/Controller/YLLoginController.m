//
//  YLLoginController.m
//  YLUCar
//
//  Created by lm on 2019/2/11.
//  Copyright © 2019 Chenzhiming. All rights reserved.
//

#import "YLLoginController.h"
#import "YLCondition.h"
#import "YLRequest.h"
#import "YLAccount.h"
#import "YLAccountTool.h"

@interface YLLoginController () <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *verificationCodeBtn;
@property (nonatomic, strong) UITextField *tel;
@property (nonatomic, strong) UITextField *message;

@end

@implementation YLLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatView];
    
}

- (void)creatView {
    CGFloat width = self.view.frame.size.width - 2 * LeftMargin;
    UILabel *attention = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, LeftMargin, width, 17)];
    attention.textColor = [UIColor grayColor];
    attention.text = @"无需注册，输入手机号码即可登录";
    attention.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:attention];
    
    UITextField *tel = [[UITextField alloc] initWithFrame:CGRectMake(LeftMargin, CGRectGetMaxY(attention.frame) + 5, width, 40)];
    tel.font = [UIFont systemFontOfSize:14];
    tel.placeholder = @"请输入您的手机号码";
    tel.keyboardType = UIKeyboardTypeNumberPad;
    tel.layer.cornerRadius = 5;
    tel.layer.borderWidth = 0.6;
    tel.layer.borderColor = [UIColor grayColor].CGColor;
    tel.layer.masksToBounds = YES;
    tel.delegate = self;
    tel.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    tel.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:tel];
    self.tel = tel;
    
    UIButton *verificationCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    verificationCodeBtn.frame = CGRectMake(width - LeftMargin - width / 4, CGRectGetMaxY(attention.frame) + 5, width / 3, 40);
    [verificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    verificationCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [verificationCodeBtn setTitleColor:YLColor(8.f, 169.f, 255.f) forState:UIControlStateNormal];
    [verificationCodeBtn addTarget:self action:@selector(getVerificationCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:verificationCodeBtn];
    self.verificationCodeBtn = verificationCodeBtn;
    
    UITextField *message = [[UITextField alloc] initWithFrame:CGRectMake(LeftMargin, CGRectGetMaxY(tel.frame) + TopMargin, width, 40)];
    message.font = [UIFont systemFontOfSize:14];
    message.placeholder = @"请输入您的短信验证码";
    message.keyboardType = UIKeyboardTypeNumberPad;
    message.layer.cornerRadius = 5;
    message.layer.borderWidth = 0.6;
    message.layer.borderColor = [UIColor grayColor].CGColor;
    message.layer.masksToBounds = YES;
    message.delegate = self;
    message.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    message.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:message];
    self.message = message;
    
    YLCondition *login = [YLCondition buttonWithType:UIButtonTypeCustom];
    login.frame = CGRectMake(LeftMargin, CGRectGetMaxY(message.frame) + TopMargin, width, 40);
    login.type = YLConditionTypeBlue;
    login.titleLabel.font = YLFont(14);
    [login setTitle:@"登录" forState:UIControlStateNormal];
    [login addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:login];
}

- (void)loginAction {
    NSLog(@"准备登录");
    [self.view endEditing:YES];
    
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:self.view];
    hub.detailsLabel.text = @"正在登录中";
    [hub showAnimated:YES];
    [self.view addSubview:hub];
    
    NSString *telephone = self.tel.text;
    NSString *verificationCode = self.message.text;
    if ([NSString isBlankString:telephone] && [NSString isBlankString:verificationCode]) {
        [NSString showMessage:@"请输入电话号码或者验证码"];
    } else {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:telephone forKey:@"telephone"];
        [param setObject:verificationCode forKey:@"code"];
        NSString *urlString = [NSString stringWithFormat:@"%@/sms?method=checkCode", YLCommandUrl];
        [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
            if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
                [hub removeFromSuperview];
                [NSString showMessage:@"登录成功"];
                YLAccount *account = [YLAccount accountWithDict:responseObject[@"data"]];
                [YLAccountTool saveAccount:account];
                [self.navigationController popViewControllerAnimated:YES];
                if (self.loginBlock) {
                    self.loginBlock(telephone);
                }
            } else {
                [hub removeFromSuperview];
                [NSString showMessage:responseObject[@"message"]];
                
            }
        } failed:nil];
    }
}

// 获取验证码
- (void)getVerificationCode {
    NSLog(@"获取验证码");
    NSString *telephone = self.tel.text;
    if ([NSString isBlankString:telephone]) {
        [NSString showMessage:@"请输入电话号码"];
    } else {
        if ([self isPhoneNumber:telephone]) {
            [self timeDown];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:telephone forKey:@"telephone"];
            NSString *urlString = [NSString stringWithFormat:@"%@/sms?method=sendSms", YLCommandUrl];
            [YLRequest GET:urlString parameters:param success:^(id  _Nonnull responseObject) {
                if ([responseObject[@"code"] isEqualToNumber:[NSNumber numberWithInteger:200]]) {
                    [NSString showMessage:@"验证码发送成功"];
                } else {
                    [NSString showMessage:@"验证码发送失败，请稍后再试"];
                }
            } failed:nil];
            
        } else {
            [NSString showMessage:@"请输入正确的电话号码"];
        }
    }
    
}

// 判断电话号码是否正确
- (BOOL) isPhoneNumber:(NSString *)number
{
    NSString *phoneRegex1=@"1[34578]([0-9]){9}";
    NSPredicate *phoneTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex1];
    return  [phoneTest1 evaluateWithObject:number];
}

// 倒计时
- (void)timeDown {
    /****************倒计时****************/
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self.verificationCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.verificationCodeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                self.verificationCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.verificationCodeBtn setTitle:[NSString stringWithFormat:@"%.2d重发", seconds] forState:UIControlStateNormal];
                [self.verificationCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                self.verificationCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

@end
