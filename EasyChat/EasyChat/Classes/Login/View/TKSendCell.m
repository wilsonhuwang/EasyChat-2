//
//  TKSendCell.m
//  EasyChat
//
//  Created by wanghu on 16/6/4.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "TKSendCell.h"

@interface TKSendCell ()
// 消息体
@property (nonatomic, weak) UIButton *messageBtn;
// 头像
@property (nonatomic, weak) UIImageView *iconImageView;
@end

@implementation TKSendCell

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
        make.right.equalTo(self.contentView.mas_right).offset(-5);
    }];
    
    UIButton *messageBtn = [[UIButton alloc] init];
    messageBtn.titleLabel.numberOfLines = 0;
    messageBtn.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    messageBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 16);
    //    messageBtn.titleLabel.preferredMaxLayoutWidth = 180.0;
    
    [messageBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [messageBtn setBackgroundImage:[UIImage imageNamed:@"chat_sender_bg"] forState:UIControlStateNormal];
    [self.contentView addSubview:messageBtn];
    self.messageBtn = messageBtn;
    [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.width.height.mas_equalTo(40);
        // 设置width区间
        make.width.lessThanOrEqualTo(@190);
        make.width.greaterThanOrEqualTo(@80);
        make.top.equalTo(iconImageView.mas_top);
        make.right.equalTo(iconImageView.mas_left);
    }];
    
}

- (void)setMessage:(EMMessage *)message
{
    _message = message;
    
    EMMessageBody *msgBody = message.body;
    switch (msgBody.type) {
        case EMMessageBodyTypeText:
        {
            // 文字消息
            EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
            
            [self.messageBtn setTitle:textBody.text forState:UIControlStateNormal];
            [self.messageBtn setImage:nil forState:UIControlStateNormal];

            [self.messageBtn layoutIfNeeded];
            
            [self.messageBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(_messageBtn.titleLabel.frame.size.height+20);
            }];
            
            [self.messageBtn layoutIfNeeded];
        }
            break;
            
        case EMMessageBodyTypeImage:
        {
            // 图片消息
            EMImageMessageBody *imageBody = (EMImageMessageBody *)msgBody;
            UIImage *image = [UIImage imageWithContentsOfFile:imageBody.thumbnailLocalPath];
            if (image) {
                [self.messageBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(image.size.height);
                }];
                
                // 避免cell循环引用残留text
                [self.messageBtn setTitle:nil forState:UIControlStateNormal];
                [self.messageBtn setImage:image forState:UIControlStateNormal];
                [self.messageBtn layoutIfNeeded];
            }
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

- (CGFloat)cellHeight
{
    CGFloat iconMaxY = CGRectGetMaxY(self.iconImageView.frame);
    CGFloat messageMaxY = CGRectGetMaxY(self.messageBtn.frame);
   
    return MAX(iconMaxY, messageMaxY) + 10;
}

@end
