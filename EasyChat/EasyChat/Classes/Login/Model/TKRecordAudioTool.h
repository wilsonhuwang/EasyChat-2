//
//  TKRecordAudioTool.h
//  EasyChat
//
//  Created by wanghu on 16/6/5.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKRecordAudioTool : NSObject

// 存储路径
@property (nonatomic, copy) NSString *path;
// 录音时间
@property (nonatomic, assign) NSInteger duration;
//+ (instancetype)shareAudioTool;

- (void)startRecordWithPath:(NSString *)path;
- (void)stopRecord;

@end
