//
//  TKAddFriendViewController.m
//  EasyChat
//
//  Created by wanghu on 16/6/4.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "TKAddFriendViewController.h"
#import "EMSDK.h"

@interface TKAddFriendViewController () <UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *headerView;

@end

@implementation TKAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = TKGlobalBgColor;
    
    // 搜索好友按钮
    UIButton *searchButton = [[UIButton alloc] init];
    [searchButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    searchButton.frame = (CGRect){0, 0, 80, 30};
    [searchButton addTarget:self action:@selector(searchFriend) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
}

- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, self.view.frame.size.width - 20, 30)];
        _textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _textField.layer.borderWidth = 0.5;
        _textField.layer.cornerRadius = 3;
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:15.0];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
    }
    
    return _textField;
}

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
        [_headerView addSubview:self.textField];
    }
    
    return _headerView;
}

- (NSMutableArray *)friends
{
    if (!_friends) {
        _friends = [NSMutableArray array];
    }
    return _friends;
}

- (void)searchFriend
{
    [self.friends removeAllObjects];
    if (self.textField.text.length <= 0)  return;
    if ([self.textField.text.lowercaseString  isEqualToString:[[[EMClient sharedClient] currentUsername] lowercaseString]]) {
        [SVProgressHUD showErrorWithStatus:@"不能添加自己为好友"];
        
    } else {
        [self.friends addObject:self.textField.text];
        [self.tableView reloadData];
    }
}

// 添加好友功能
- (void)showAddFriend:(NSString *)name
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"想对他说些什么" preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加附加信息输入框
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        // textField 各种设置
    }];
    [self presentViewController:alert animated:YES completion:nil];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *add = [UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields.lastObject;
        [[EMClient sharedClient].contactManager addContact:name message:textField.text];
    }];
    [alert addAction:cancel];
    [alert addAction:add];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"friends";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    cell.textLabel.text = self.friends[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showAddFriend:self.friends[indexPath.row]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

@end
