//
//  TKFriendListController.m
//  EasyChat
//
//  Created by wanghu on 16/6/4.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "TKFriendListController.h"
#import "TKAddFriendViewController.h"
#import "TKChatViewController.h"
#import "EMSDK.h"

@interface TKFriendListController ()

@property (nonatomic, strong) NSArray *buddyList;
@end

@implementation TKFriendListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TKGlobalBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 添加好友按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriends)];
    
    [self loadFriends];
}
- (void)loadFriends
{
    EMError *error = nil;
    self.buddyList = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (!error) {
        
    } else {
        NSLog(@"%@", error);
    }
}

// 添加好友
- (void)addFriends
{
    //    EMError *error = [[EMClient sharedClient].contactManager addContact:@"6001" message:@"我想加您为好友"];
    TKAddFriendViewController *addVC = [[TKAddFriendViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.buddyList.count;
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
    cell.imageView.image = [UIImage imageNamed:@"setup-head-default"];
    cell.textLabel.text = self.buddyList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TKChatViewController *chatVc = [[TKChatViewController alloc] init];
    chatVc.buddy = self.buddyList[indexPath.row];
    [self.navigationController pushViewController:chatVc animated:YES];
}

@end
