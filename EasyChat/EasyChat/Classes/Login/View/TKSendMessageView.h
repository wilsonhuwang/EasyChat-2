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
// 文字改变
//- (void)sendMessageView:(TKSendMessageView *)sendMessageView putInWord:(NSString *)text allWord:(UITextView *)textView;
@optional
// 图片按钮点击
- (void)sendMessageViewDidSelectImage:(TKSendMessageView *)sendMessageView;
// 语音发送按钮点击
- (void)sendMessageViewDidAudioRecord:(TKSendMessageView *)sendMessageView;
@end

@interface TKSendMessageView : UIView
@property (nonatomic, weak) id <TKSendMessageViewDelegate> delegate;
@end
