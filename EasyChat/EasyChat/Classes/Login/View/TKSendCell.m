//
//  TKSendCell.m
//  EasyChat
//
//  Created by wanghu on 16/6/4.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "TKSendCell.h"
#import <AVFoundation/AVFoundation.h>

@interface TKSendCell ()
// 消息体
@property (nonatomic, weak) UIButton *messageBtn;
// 头像
@property (nonatomic, weak) UIImageView *iconImageView;
// audio计时器
@property (nonatomic, strong) CADisplayLink *audioTimer;
// 语音消息的剩余时间
@property (nonatomic, assign) NSInteger audioDurcation;
// 语音消息的最大时间
@property (nonatomic, assign) NSInteger recordTime;
// 语音消息的本地地址
@property (nonatomic, copy)NSString *audioPath;

@property (nonatomic, assign) NSInteger maxIndex;
@property (nonatomic, strong) NSArray *indexs;
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
    self.maxIndex = 0;
    self.indexs = @[@"3", @"2", @"1", @"0", @"1", @"2"];
    
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
    messageBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 14);
    messageBtn.titleLabel.preferredMaxLayoutWidth = 170.0;
    self.messageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [messageBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [messageBtn setBackgroundImage:[UIImage imageNamed:@"chat_sender_bg"] forState:UIControlStateNormal];
    [self.contentView addSubview:messageBtn];
    self.messageBtn = messageBtn;
    [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
        {
            EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
            self.audioDurcation = body.duration;
            self.recordTime = body.duration;
            self.audioPath = body.localPath;
            [self.messageBtn setImage:[UIImage imageNamed:@"chat_sender_audio_playing_full"] forState:UIControlStateNormal];
            [self.messageBtn setTitle:[NSString stringWithFormat:@"%d\"", body.duration] forState:UIControlStateNormal];
            [self.messageBtn addTarget:self action:@selector(playerAudio) forControlEvents:UIControlEventTouchUpInside];
            
        }
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

#pragma mark - audio消息处理
- (void)playerAudio
{
    [self startTimer];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)([NSURL URLWithString:self.audioPath]), &soundID);
    AudioServicesPlaySystemSound(soundID);
}

- (void)startTimer
{
    self.audioTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(recordAudioTime)];
    self.audioTimer.frameInterval = 30;
    [self.audioTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)recordAudioTime
{
    --self.audioDurcation;
    [UIView animateWithDuration:1.0 animations:^{
        [self.messageBtn setTitle:[NSString stringWithFormat:@"%d\"", self.audioDurcation] forState:UIControlStateNormal];
        [self.messageBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"chat_sender_audio_playing_00%@", self.indexs[self.maxIndex++]]] forState:UIControlStateNormal];
        if (self.maxIndex == self.indexs.count) {
            self.maxIndex = 0;
        }
    }];
    
    if (self.audioDurcation < 0) {
        [self stopTimer];
    }
}

- (void)stopTimer
{
    [self.audioTimer invalidate];
    self.audioTimer = nil;
    self.audioDurcation = self.recordTime;
    [self.messageBtn setImage:[UIImage imageNamed:@"chat_sender_audio_playing_full"] forState:UIControlStateNormal];
    [self.messageBtn setTitle:[NSString stringWithFormat:@"%d\"", self.audioDurcation] forState:UIControlStateNormal];
}

@end
