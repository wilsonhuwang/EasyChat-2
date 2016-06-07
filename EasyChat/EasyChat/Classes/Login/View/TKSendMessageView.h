//
//  TKSendMessageView.h
//  EasyChat
//
//  Created by wanghu on 16/6/4.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TKSendMessageView;
@protocol TKSendMessageViewDelegate <NSObject>

@required
// 所有字符
- (void)sendMessageView:(TKSendMessageView *)sendMessageView allWord:(UITextView *)textView;
@optional
// 图片按钮点击
- (void)sendMessageViewDidSelectImage:(TKSendMessageView *)sendMessageView;
// 开始录音
- (void)sendMessageViewBeginAudioRecord:(TKSendMessageView *)sendMessageView;
// 结束录音
- (void)sendMessageViewEndAudioRecord:(TKSendMessageView *)sendMessageView;
@end

@interface TKSendMessageView : UIView
@property (nonatomic, weak) id <TKSendMessageViewDelegate> delegate;
@end
