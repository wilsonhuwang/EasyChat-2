//
//  TKReciveCell.m
//  EasyChat
//
//  Created by wanghu on 16/6/4.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "TKReciveCell.h"

@interface TKReciveCell ()
// 消息体
@property (nonatomic, weak) UIButton *messageBtn;
// 头像
@property (nonatomic, weak) UIImageView *iconImageView;
@end

@implementation TKReciveCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = TKGlobalBgColor;
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:@"setup-head-default"];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(36);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(5);
    }];
    
    UIButton *messageBtn = [[UIButton alloc] init];
    messageBtn.titleLabel.numberOfLines = 0;
    messageBtn.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
//    messageBtn.titleLabel.preferredMaxLayoutWidth = 180.0;
    
    [messageBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [messageBtn setBackgroundImage:[UIImage imageNamed:@"chat_receiver_bg"] forState:UIControlStateNormal];
    [self.contentView addSubview:messageBtn];
    self.messageBtn = messageBtn;
    [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(40);
        // 设置width区间
        make.width.lessThanOrEqualTo(@190);
        make.width.greaterThanOrEqualTo(@80);
        make.top.equalTo(iconImageView.mas_top);
        make.left.equalTo(iconImageView.mas_right);
    }];
    
}

- (void)setMessage:(EMMessage *)message
{
    _message = message;
    
    EMMessageBody *msgBody = message.body;
    switch (msgBody.type) {
        case EMMessageBodyTypeText:
        {
            // 收到的文字消息
            EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
            [self.messageBtn setTitle:textBody.text forState:UIControlStateNormal];
            
            [self.messageBtn layoutIfNeeded];
//            NSLog(@"%@", NSStringFromCGRect(self.messageBtn.titleLabel.frame));
            [self.messageBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(_messageBtn.titleLabel.frame.size.height+20);
            }];
        }
            break;
        case EMMessageBodyTypeImage:
        {
        }
            break;
        case EMMessageBodyTypeLocation:
            break;
        case EMMessageBodyTypeVoice:
            break;
        case EMMessageBodyTypeVideo:
            break;
        case EMMessageBodyTypeFile:
            
        default:
            break;
    }
}

@end
