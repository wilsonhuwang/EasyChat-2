//
//  TKSettingViewController.m
//  EasyChat
//
//  Created by wanghu on 16/6/5.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "TKSettingViewController.h"
#import "TKLoginViewController.h"
#import "EMSDK.h"

@interface TKSettingViewController ()

@end

@implementation TKSettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"setting";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        UISwitch *autoLogin = [[UISwitch alloc] init];
        autoLogin.on = [EMClient sharedClient].options.isAutoLogin;
        [autoLogin addTarget:self action:@selector(autoLoginChoose:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = autoLogin;
    }
    cell.textLabel.text = @"开启自动登录";
    return cell;
}

- (void)autoLoginChoose:(UISwitch *)autoLogin
{
    if (autoLogin.isOn) {
        // 开启自动登录
        [[EMClient sharedClient].options setIsAutoLogin:YES];
    } else {
        // 关闭自动登录
        [[EMClient sharedClient].options setIsAutoLogin:NO];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    UIView *bgView = [[UIView alloc] init];
//    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self.view.mas_width);
//        make.height.mas_equalTo(35);
//    }];
    
    UIButton *logoutBtn = [[UIButton alloc] init];
    [logoutBtn setTitle:@"注销登录" forState:UIControlStateNormal];
    logoutBtn.backgroundColor = [UIColor redColor];
    [logoutBtn addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
//    [bgView addSubview:logoutBtn];
    return logoutBtn;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 35;
}

// 退出登录
- (void)logoutClick
{
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        keyWindow.rootViewController = [[TKLoginViewController alloc] init];
        [[EMClient sharedClient].options setIsAutoLogin:NO];
    }
}
@end
