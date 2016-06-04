//
//  TKLoginViewController.m
//  EasyChat
//
//  Created by wanghu on 16/6/3.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "TKLoginViewController.h"
#import "TKMainViewController.h"
#import "EMSDK.h"

@interface TKLoginViewController () <UITextFieldDelegate>
// 账号
@property (nonatomic, weak) UITextField *nameField;
// 密码
@property (nonatomic, weak) UITextField *pwdField;
// 注册
@property (nonatomic, weak) UIButton *registerBtn;
// 登录
@property (nonatomic, weak) UIButton *loginBtn;
@end

@implementation TKLoginViewController

static NSString * const NameKey = @"nameKey";
static NSString * const PwdKey = @"pwdKey";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"随意聊";
    self.view.backgroundColor = TKGlobalBgColor;
    // 登录界面创建
    [self setupLoginView];
    // 取出存储的账号密码
    [self putOutAccountAndPwd];
}

// 取出存储的账号密码
- (void)putOutAccountAndPwd
{
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:NameKey];
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:PwdKey];
    
    if (name.length && pwd.length) {
        self.nameField.text = name;
        self.pwdField.text = pwd;
    }
}

// 添加登录界面

- (void)setupLoginView
{
    UIView *loginView = [[UIView alloc] init];
//    loginView.backgroundColor = [UIColor redColor];
    [self.view addSubview:loginView];
    
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.center.equalTo(self.view);
        make.height.mas_equalTo(150);
        
    }];
    
    // 添加账号输入框，添加约束
    UITextField *nameField = [[UITextField alloc] init];
    nameField.backgroundColor = [UIColor whiteColor];
    nameField.placeholder = @"请输入账号";
    nameField.delegate = self;
    nameField.returnKeyType = UIReturnKeyNext;
    self.nameField = nameField;
    [loginView addSubview:nameField];
    
    [nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@200);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(loginView.mas_centerX);
        make.top.equalTo(loginView.mas_top).offset(10);
    }];
    
    // 添加密码输入框，添加约束
    UITextField *pwdField = [[UITextField alloc] init];
    pwdField.backgroundColor = [UIColor whiteColor];
    pwdField.placeholder = @"请输入密码";
    pwdField.secureTextEntry = YES;
    pwdField.delegate = self;
    pwdField.returnKeyType = UIReturnKeyGo;
    [loginView addSubview:pwdField];
    self.pwdField = pwdField;
    
    [pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(nameField.mas_width);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(loginView.mas_centerX);
        make.top.equalTo(nameField.mas_bottom).offset(10);
    }];
    
    // 添加注册按钮，添加约束
    UIButton *registerBtn = [[UIButton alloc] init];
    registerBtn.backgroundColor = [UIColor redColor];
    [loginView addSubview:registerBtn];
    self.registerBtn = registerBtn;
    
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
//    [registerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(pwdField.mas_width).multipliedBy(0.5);
        make.left.equalTo(pwdField.mas_left);
        make.top.equalTo(pwdField.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    // 添加登录按钮，添加约束
    UIButton *loginBtn = [[UIButton alloc] init];
    loginBtn.backgroundColor = [UIColor darkGrayColor];
    [loginView addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
//    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.equalTo(registerBtn);
        make.left.equalTo(registerBtn.mas_right);
    }];
}

// 注册账号
- (void)registerBtnClick
{
    
    NSString *account = self.nameField.text;
    NSString *pwd = self.pwdField.text;
    EMError *error = [[EMClient sharedClient] registerWithUsername:account password:pwd];
    if (error) {
        NSLog(@"注册失败%@", error.description);
        [SVProgressHUD showErrorWithStatus:@"注册失败"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
    }
}

// 登录账号
- (void)loginBtnClick
{    EMError *error = [[EMClient sharedClient] loginWithUsername:self.nameField.text password:self.pwdField.text];
    if (!error) {
        //        [[EMClient sharedClient].options setIsAutoLogin:YES];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[TKMainViewController alloc] init];
        // 存储账号密码
        [[NSUserDefaults standardUserDefaults] setObject:self.nameField.text forKey:NameKey];
        [[NSUserDefaults standardUserDefaults] setObject:self.pwdField.text forKey:PwdKey];
        
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameField) {
        [self.nameField resignFirstResponder];
        [self.pwdField becomeFirstResponder];
    } else {
        [self loginBtnClick];
    }
    return NO;
}

// 退出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//- (void)showError
//{
//    if (self.nameField.text.length && self.pwdField.text.length) return;
//    [SVProgressHUD showErrorWithStatus:@"账号和密码不能为空"];
//}

@end
