//
//  TKChatViewController.m
//  EasyChat
//
//  Created by wanghu on 16/6/4.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "TKChatViewController.h"
#import "TKSendMessageView.h"

@interface TKChatViewController ()
@property (nonatomic, strong) TKSendMessageView *sendView;
@end

@implementation TKChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TKGlobalBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupSendView];
    
}

- (void)setupSendView
{
    TKSendMessageView *sendView = [[TKSendMessageView alloc] init];
    self.sendView = sendView;
    [sendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@35);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

@end
