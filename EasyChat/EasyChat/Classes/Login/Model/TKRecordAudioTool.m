//
//  TKRecordAudioTool.m
//  EasyChat
//
//  Created by wanghu on 16/6/5.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "TKRecordAudioTool.h"
#import <AVFoundation/AVFoundation.h>

@interface TKRecordAudioTool ()
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) CADisplayLink *durationTime;
@end

@implementation TKRecordAudioTool

//static TKRecordAudioTool *_audioTool;
//
//#pragma mark - 生成单例
//+ (instancetype)allocWithZone:(struct _NSZone *)zone
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _audioTool = [super allocWithZone:zone];
//    });
//    return _audioTool;
//}
//
//+ (instancetype)shareAudioTool
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _audioTool = [[self alloc] init];
//    });
//    return _audioTool;
//}
//
//- (id)copyWithZone:(NSZone *)zone
//{
//    return _audioTool;
//}

- (void)recordTime
{
//    NSLog(@"--------");
}

- (void)addtimer
{
    self.durationTime = [CADisplayLink displayLinkWithTarget:self selector:@selector(recordTime)];
    [self.durationTime addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopTimer
{
    [self.durationTime invalidate];
    self.durationTime = nil;
}


- (void)startRecordWithPath:(NSString *)path
{
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:path] settings:nil error:nil];
    self.path = path;
    [self.recorder prepareToRecord];
    self.recorder.meteringEnabled = YES;
    [self.recorder record];
    [self addtimer];
}

- (void)stopRecord
{
    [self.recorder stop];
    self.duration = (int)(self.durationTime.duration * 1000);
    [self stopTimer];
}



@end

