//
//  TKSendMessageView.m
//  EasyChat
//
//  Created by wanghu on 16/6/4.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "TKSendMessageView.h"
@interface TKSendMessageView () <UITextViewDelegate>
// 语音发送按钮
@property (nonatomic, weak) UIButton *audio;
// 图片选择按钮
@property (nonatomic, weak) UIButton *selectImageBtn;
@end

@implementation TKSendMessageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        [self setup];
    }
    return self;
}

- (void)setup
{
    // 添加音频按钮
    UIButton *audio = [[UIButton alloc] init];
    [audio setImage:[UIImage imageNamed:@"chatBar_record"] forState:UIControlStateNormal];
    [audio setImage:[UIImage imageNamed:@"chatBar_recordSelected"] forState:UIControlStateSelected];
    [audio addTarget:self action:@selector(audioClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:audio];
    
    self.audio = audio;
    
    // 添加音频按钮约束
    [audio mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.left.equalTo(self.mas_left).offset(5);
        make.top.equalTo(self.mas_top).offset(5);
    }];
    
    // 添加图片选按钮
    UIButton *selectImageBtn = [[UIButton alloc] init];
    [self addSubview:selectImageBtn];
    [selectImageBtn setImage:[UIImage imageNamed:@"chatBar_more"] forState:UIControlStateNormal];
    [selectImageBtn setImage:[UIImage imageNamed:@"chatBar_moreSelected"] forState:UIControlStateSelected];
    [selectImageBtn addTarget:self action:@selector(selectImageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectImageBtn = selectImageBtn;
    
    // 添加图片选择按钮按钮约束
    [selectImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.right.equalTo(self.mas_right).offset(-5);
        make.top.equalTo(self.mas_top).offset(5);
    }];
    
    // 添加输入框
    UITextView *textView = [[UITextView alloc] init];
    textView.backgroundColor =[UIColor whiteColor];
    textView.delegate = self;
    textView.returnKeyType = UIReturnKeySend;
    [self addSubview:textView];
    textView.font = [UIFont systemFontOfSize:16.0];
    
    // 添加输入框约束
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(selectImageBtn.mas_left).offset(-5);
        make.left.equalTo(audio.mas_right).offset(5);
        make.top.equalTo(self.mas_top).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    [self.delegate sendMessageView:self allWord:textView];
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if ([text isEqualToString:@"\n"]) {
//        [self.delegate sendMessageView:self putInWord:text allWord:textView];
//        return NO;
//    }
//    return YES;
//}

// 选择图片点击
- (void)selectImageBtnClick
{
    self.selectImageBtn.selected = !self.selectImageBtn.isSelected;
    if ([self.delegate respondsToSelector:@selector(sendMessageViewDidSelectImage:)]) {
        [self.delegate sendMessageViewDidSelectImage:self];
    }
}

// 语音按钮点击
- (void)audioClick
{
    self.audio.selected =!self.audio.isSelected;
    if ([self.delegate respondsToSelector:@selector(sendMessageViewDidAudioRecord:)]) {
        [self.delegate sendMessageViewDidAudioRecord:self];
    }
}

@end
