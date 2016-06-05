//
//  TKChatViewController.m
//  EasyChat
//
//  Created by wanghu on 16/6/4.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "TKChatViewController.h"
#import "TKSendMessageView.h"
#import "TKReciveCell.h"
#import "TKSendCell.h"
#import "EMSDK.h"

@interface TKChatViewController () <UITableViewDelegate, UITableViewDataSource, TKSendMessageViewDelegate, EMChatManagerDelegate>
// 消息输入栏
@property (nonatomic, weak) TKSendMessageView *sendView;
// 对话显示栏
@property (nonatomic, weak) UITableView *chatNewsView;
// 所有消息
@property (nonatomic, strong) NSMutableArray *chatNews;
// 当前会话对象
@property (nonatomic, strong) EMConversation *currentConversation;
// 用于计算cell高度
@property (nonatomic, strong) TKSendCell *cellHeightTool;
// 输入的文字消息
@property (nonatomic, copy) NSString *messageText;

@end

@implementation TKChatViewController

static NSString * const reciveId = @"reciveId";
static NSString * const sendId = @"sendId";

- (NSMutableArray *)chatNews
{
    if (!_chatNews) {
        _chatNews = [NSMutableArray array];
    }
    return _chatNews;
}

- (TKSendCell *)cellHeightTool
{
    if (!_cellHeightTool) {
        _cellHeightTool = [[TKSendCell alloc] init];
    }
    return _cellHeightTool;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TKGlobalBgColor;
    self.title = self.buddy;
;
    // 获取会话
    self.currentConversation = [[EMClient sharedClient].chatManager getConversation:self.buddy type:EMConversationTypeChat createIfNotExist:YES];
    //消息回调:EMChatManagerChatDelegate
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    // 添加消息输入栏
    [self setupSendView];
    // 添加聊天展示栏
    [self setupChatNewsView];
    
    // 加载历史消息
    [self loadHistoryNews];
    
    // 键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}

// 加载历史消息
- (void)loadHistoryNews
{
    NSArray *news = [self.currentConversation loadMoreMessagesFromId:nil limit:20 direction:EMMessageSearchDirectionUp];
    [self.chatNews addObjectsFromArray:news];
    [self.chatNewsView reloadData];
    [self scrollToBottom];
}

// 添加消息输入栏
- (void)setupSendView
{
    TKSendMessageView *sendView = [[TKSendMessageView alloc] init];
    self.sendView = sendView;
    sendView.delegate = self;
    [self.view addSubview:sendView];
    
    // 添加约束
    [sendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

// 添加聊天展示栏
- (void)setupChatNewsView
{
     UITableView *chatNewsView = [[UITableView alloc] init];
    chatNewsView.separatorStyle = UITableViewCellSeparatorStyleNone;
    chatNewsView.dataSource = self;
    chatNewsView.delegate = self;
    chatNewsView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    chatNewsView.allowsSelection = NO;
    
    [self.view addSubview:chatNewsView];
    self.chatNewsView = chatNewsView;
    
    // 添加约束
    [self.chatNewsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.sendView.mas_top);
        make.top.equalTo(self.view.mas_top);
    }];
    
    // 注册tableViewCell
    [self.chatNewsView registerClass:[TKSendCell class] forCellReuseIdentifier:sendId];
    [self.chatNewsView registerClass:[TKReciveCell class] forCellReuseIdentifier:reciveId];
}

// 键盘弹出通知
- (void)keyBoardShow:(NSNotification *)noti
{
     CGRect keyF = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self.sendView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-keyF.size.height);
    }];
    
    [UIView animateWithDuration:0.23 animations:^{
        [self.view layoutIfNeeded];
    }];
    
//    NSLog(@"%@", NSStringFromCGRect(keyF));
//    NSLog(@"%@", NSStringFromCGRect(self.sendView.frame));
}
// 键盘隐藏通知
- (void)keyBoardHidden:(NSNotification *)noti
{
//    CGRect keyF = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self.sendView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    [UIView animateWithDuration:0.23 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatNews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    EMMessage *messge = self.chatNews[indexPath.row];
    if (messge.direction == EMMessageDirectionSend) {
        TKSendCell *cell = [tableView dequeueReusableCellWithIdentifier:sendId];
        cell.message = messge;
        return cell;
    } else {
        TKReciveCell *cell = [tableView dequeueReusableCellWithIdentifier:reciveId];
        cell.message = messge;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.cellHeightTool.message = self.chatNews[indexPath.row];
    return self.cellHeightTool.cellHeight;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 退出键盘
    [self.view endEditing:YES];
}

#pragma mark - TKSendMessageViewDelegate
- (void)sendMessageView:(TKSendMessageView *)sendMessageView allWord:(UITextView *)textView
{
    // 根据输入的文字改变sendView的高度
    CGFloat height = 0;
    CGFloat minHeight = 30;
    CGFloat maxHeight = 150;
    CGFloat contentHeight = textView.contentSize.height;
    if (contentHeight < minHeight) {
        height = minHeight;
    } else if (contentHeight > maxHeight) {
        height = maxHeight;
    } else {
        height = contentHeight;
    }
    [self.sendView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(contentHeight + 10));
    }];
    
    
    
    if ([textView.text hasSuffix:@"\n"]) {
        // 发送消息
        [self sendMessage:self.messageText];
        [textView setContentOffset:CGPointZero];
        textView.text = nil;
        [self.sendView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.equalTo(@40);
        }];
    }
    
    self.messageText = textView.text;
}

// 发送文字
- (void)sendMessage:(NSString *)messageText
{
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:messageText];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.currentConversation.conversationId from:from to:self.buddy body:body ext:nil];
    message.chatType = EMChatTypeChat;// 设置为单聊消息
    //message.chatType = EMChatTypeGroupChat;// 设置为群聊消息
    //message.chatType = EMChatTypeChatRoom;// 设置为聊天室消息
    [self.chatNews addObject:message];
    [self.chatNewsView reloadData];
    [self scrollToBottom];
    
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:^(int progress) {
        
    } completion:^(EMMessage *message, EMError *error) {
        
    }];
}

/*!
 @method
 @brief 接收到一条及以上非cmd消息
 */
- (void)didReceiveMessages:(NSArray *)aMessages
{
    [self.chatNews addObjectsFromArray:aMessages];
    [self.chatNewsView reloadData];
    [self scrollToBottom];
}


// chatNewsView 滚到底部
- (void)scrollToBottom
{
    if (self.chatNews.count <= 0) return;
    NSIndexPath *index = [NSIndexPath indexPathForRow:self.chatNews.count - 1 inSection:0];
    [self.chatNewsView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //移除消息回调
    [[EMClient sharedClient].chatManager removeDelegate:self];
}


@end
