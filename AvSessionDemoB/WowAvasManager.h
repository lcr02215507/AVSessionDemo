//
//  WowAvasManager.h
//  AvSessionDemoB
//
//  Created by lcr on 2025/3/7.
//  Copyright © 2025 ali. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AvsCategoryType) {
    AvsCategoryTypeAmbient,
    AvsCategoryTypeSoloAmbient,
    AvsCategoryTypePlayback,
    AvsCategoryTypeRecord,
    AvsCategoryTypePlayAndRecord,
    AvsCategoryTypeMultiRoute
};

typedef NS_ENUM(NSInteger, AvsCategoryOptions) {
    AvsCategoryOptionOptionMixWithOthers     = 0x1,
    AvsCategoryOptionDuckOthers              = 0x2,
    AvsCategoryOptionAllowBluetooth          = 0x4,
    AvsCategoryOptionDefaultToSpeaker        = 0x8,
    AvsCategoryOptionInterruptSpokenAudioAndMixWithOthers = 0x11,
    AvsCategoryOptionAllowBluetoothA2DP      = 0x20,
    AvsCategoryOptionAllowAirPlay            = 0x40,
    AvsCategoryOptionOverrideMutedMicrophoneInterruption = 0x80,
};

@interface WowAvasManager : NSObject

@property (nonatomic, assign) AvsCategoryType currentCategory;
@property (nonatomic, assign) AvsCategoryOptions currentOption;
@property (nonatomic, assign) NSInteger isinterupted;
@property (nonatomic) BOOL sessionUsedByOther; // session焦点是否正在被别的app占用


+ (instancetype)sharedInstance;

// 设置当前 应用 [AVAudioSession sharedInstance] 音频使用模式
-(BOOL)setAvsCategory:(AvsCategoryType)category;

//withOptions 可选项 可配合Category实现多使用场景 使用规则参考下方链接
-(BOOL)setAvsCategory:(AvsCategoryType)category withOptions:(AvsCategoryOptions)option;

// 抢占或释放音频焦点
-(BOOL)setAvsActive:(BOOL)active withOptions:(BOOL)option;

@end

NS_ASSUME_NONNULL_END

/**
 https://aliyuque.antfin.com/wpf242951/wow_ios/xosgnqwvrrebu3vc
 */
