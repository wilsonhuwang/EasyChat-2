//
//  TKRecordTip.m
//  EasyChat
//
//  Created by wanghu on 16/6/5.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "TKRecordTip.h"

@implementation TKRecordTip

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:@"松手发送语音" forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"chatBar_recordSelected"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"chatBar_recordSelectedBg"] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.titleLabel.contentMode = UIViewContentModeCenter;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置imageview center
    self.imageView.frame = CGRectMake(0, self.imageView.image.size.height, self.imageView.image.size.width, self.imageView.image.size.height);
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width * 0.5;
    self.imageView.center = center;
    
    // 设置titleLabel frame
    CGFloat x = 0;
    CGFloat y = CGRectGetMaxY(self.imageView.frame);
    CGFloat h = self.frame.size.height - y;
    CGFloat w = self.frame.size.width;
    
    self.titleLabel.frame = CGRectMake(x, y, w, h);
}

@end
