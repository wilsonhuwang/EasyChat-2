//
//  TKConverseListController.m
//  EasyChat
//
//  Created by wanghu on 16/6/4.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "TKConverseListController.h"
#import "TKChatViewController.h"
#import "TKSettingViewController.h"
#import "EMSDK.h"

@interface TKConverseListController () <EMContactManagerDelegate>
// 所有会话
@property (nonatomic, strong) NSMutableArray *conversations;
// 好友名字
@property (nonatomic, strong) NSMutableArray *buddies;
@end

@implementation TKConverseListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TKGlobalBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setBtnClick)];
}

// 进入set界面
- (void)setBtnClick
{
    TKSettingViewController *vc = [[TKSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)conversations
{
    if (!_conversations) {
        _conversations = [NSMutableArray array];
    }
    return _conversations;
}


- (NSMutableArray *)buddies
{
    if (!_buddies) {
        _buddies = [NSMutableArray array];
    }
    return _buddies;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.conversations addObjectsFromArray:[[EMClient sharedClient].chatManager getAllConversations]];
}

- (void)dealloc
{
    [[EMClient sharedClient].contactManager removeDelegate:self];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"conversation";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    EMConversation *conversation = self.conversations[indexPath.row];
    EMMessage *lastMessage = conversation.latestMessage;
    NSString *buddyName = nil;
    if ([lastMessage.from isEqualToString:[[EMClient sharedClient] currentUsername]]) {
        buddyName = lastMessage.to;
    } else {
        buddyName = lastMessage.from;
    }
    if (buddyName) {
        [self.buddies addObject:buddyName];
    }
    cell.imageView.image = [UIImage imageNamed:@"setup-head-default"];
    cell.textLabel.text = buddyName;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TKChatViewController *vc = [[TKChatViewController alloc] init];
    vc.buddy = self.buddies[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除会话
        [[EMClient sharedClient].chatManager deleteConversation:self.buddies[indexPath.row] deleteMessages:YES];
        [self.conversations removeObjectAtIndex:indexPath.row];
        [self.buddies removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B同意后，用户A会收到这个回调
 */
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername
{
    
}

/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B拒绝后，用户A会收到这个回调
 */
- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername
{
    
}
@end
