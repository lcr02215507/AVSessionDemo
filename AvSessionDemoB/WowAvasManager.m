//
//  WowAvasManager.m
//  AvSessionDemoB
//
//  Created by lcr on 2025/3/7.
//  Copyright © 2025 ali. All rights reserved.
//

#import "WowAvasManager.h"
#import <AVFoundation/AVFoundation.h>

@implementation WowAvasManager

+ (instancetype)sharedInstance {
    static WowAvasManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WowAvasManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        //注册通知
        //其他App或者系统打断电话、闹铃等通知 AVAudioSessionInterruptionNotification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleAudioSessionInterruption:)
                                                     name:AVAudioSessionInterruptionNotification
                                                   object:[AVAudioSession sharedInstance]];
        // 其他App占据AudioSession的时候用 AVAudioSessionSilenceSecondaryAudioHintNotification。
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleAudioSessionHint:)
                                                     name:AVAudioSessionSilenceSecondaryAudioHintNotification
                                                   object:[AVAudioSession sharedInstance]];
        
        // 外设改变 通知
        // AVAudioSessionRouteChangeNotification
        

        
    }
    return self;
}

-(BOOL)setAvsCategory:(AvsCategoryType)category{
    _currentCategory = category;
    return [self setAvsCategory:category withOptions:0];
}

-(BOOL)setAvsCategory:(AvsCategoryType)category withOptions:(AvsCategoryOptions)option{
    _currentOption = option;
    NSInteger optValue = (NSInteger)option;
    switch (category) {
        case AvsCategoryTypeAmbient:
            return [self setCategory:AVAudioSessionCategoryAmbient withOptions:optValue];
            break;
        case AvsCategoryTypeSoloAmbient:
            return [self setCategory:AVAudioSessionCategorySoloAmbient withOptions:optValue];
            break;
        case AvsCategoryTypePlayback:
            return [self setCategory:AVAudioSessionCategoryPlayback withOptions:optValue];
            break;
        case AvsCategoryTypePlayAndRecord:
            return [self setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:optValue];
            break;
        case AvsCategoryTypeMultiRoute:
            return [self setCategory:AVAudioSessionCategoryMultiRoute withOptions:optValue];
            break;
            
        default:
            break;
    }
    return YES;
}

-(BOOL)setCategory:(AVAudioSessionCategory)category withOptions:(NSInteger)option
{
    if (option == 0){
        NSError *error = nil;
        if ([[AVAudioSession sharedInstance] setCategory:category error:&error] == NO){
            NSLog(@"%@",error);
            return NO;
        }
    }else{
        AVAudioSessionCategoryOptions optionV = (AVAudioSessionCategoryOptions)option;
        NSError *error = nil;
        if ([[AVAudioSession sharedInstance] setCategory:category withOptions:optionV error:&error] == NO){
            NSLog(@"%@",error);
            return NO;
        }
    }
    return YES;
}

-(BOOL)setAvsActive:(BOOL)active withOptions:(BOOL)option{
    NSError *error = nil;
    if (option){
        if ([[AVAudioSession sharedInstance] setActive:active withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error] == NO){
            NSLog(@"%@",error);
            return NO;
        }
    }else{
        if ([[AVAudioSession sharedInstance] setActive:active error:&error] == NO){
            NSLog(@"%@",error);
            return NO;
        }
    }
    return YES;
}

#pragma mark -- handleNoti
- (void)handleAudioSessionInterruption:(NSNotification *)notification {
    AVAudioSessionInterruptionType interruptionType = [[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    
    switch (interruptionType) {
        case AVAudioSessionInterruptionTypeBegan:
            // 处理中断开始，例如暂停播放
            NSLog(@"Audio session was interrupted");
            //[self setAvsActive:YES withOptions:NO];
            break;
        case AVAudioSessionInterruptionTypeEnded: {
            AVAudioSessionInterruptionOptions options = [[notification.userInfo valueForKey:AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
            if (options & AVAudioSessionInterruptionOptionShouldResume) {
                // 处理中断结束，例如恢复播放
                NSLog(@"Audio session interruption ended, should resume");
                [self setAvsActive:YES withOptions:NO];
            } else {
                // 如果没有应恢复的选项，可能需要做一些清理工作
                NSLog(@"Audio session interruption ended, should not resume");
            }
            break;
        }
    }
}

-(void)handleAudioSessionHint:(NSNotification *)notification
{
    AVAudioSessionSilenceSecondaryAudioHintType interruptionType = [[notification.userInfo valueForKey:AVAudioSessionSilenceSecondaryAudioHintTypeKey] unsignedIntegerValue];
    
    switch (interruptionType) {
        case AVAudioSessionSilenceSecondaryAudioHintTypeBegin:
            // session 开始被别的占用
            NSLog(@"Audio session was robbed begin");
            //[self setAvsActive:YES withOptions:NO];
            break;
        case AVAudioSessionSilenceSecondaryAudioHintTypeEnd: {
            
            // 处理中断结束，例如恢复播放
            NSLog(@"Audio session was robbed end");
            //[self setAvsActive:YES withOptions:NO];
           
            break;
        }
    }
}



- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
