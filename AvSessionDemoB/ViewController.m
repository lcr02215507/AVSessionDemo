//
//  ViewController.m
//  AvSessionDemoB
//
//  Created by lcr on 2025/3/4.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()<AVAudioPlayerDelegate>

@property (nonatomic , strong) AVAudioPlayer *player;

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *stopBtn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Maroon 5-Sugar" withExtension:@"mp3"];
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    self.player.delegate = self;
}

-(void)initUI
{
    UILabel *topLb = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, 180, 50)];
    topLb.text = @"应用B-sugar";
    topLb.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:topLb];
    
    
    UIButton *playB = [UIButton buttonWithType:UIButtonTypeCustom];
    [playB setTitle:@"播放" forState:UIControlStateNormal];
    [playB setBackgroundColor:[UIColor blueColor]];
    [playB addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    playB.frame = CGRectMake(100, 200, 100, 60);
    self.playBtn = playB;
    [self.view addSubview:playB];
    
    UIButton *stopB = [UIButton buttonWithType:UIButtonTypeCustom];
    [stopB setTitle:@"停止" forState:UIControlStateNormal];
    [stopB setBackgroundColor:[UIColor redColor]];
    [stopB addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    stopB.frame = CGRectMake(100, 300, 100, 60);
    self.stopBtn = stopB;
    [self.view addSubview:stopB];
    
    UIButton *soloB = [UIButton buttonWithType:UIButtonTypeCustom];
    [soloB setTitle:@"获取焦点" forState:UIControlStateNormal];
    [soloB setBackgroundColor:[UIColor purpleColor]];
    [soloB addTarget:self action:@selector(solo) forControlEvents:UIControlEventTouchUpInside];
    soloB.frame = CGRectMake(100, 500, 200, 60);
    [self.view addSubview:soloB];
    
    UIButton *nogetB = [UIButton buttonWithType:UIButtonTypeCustom];
    [nogetB setTitle:@"释放焦点" forState:UIControlStateNormal];
    [nogetB setBackgroundColor:[UIColor purpleColor]];
    [nogetB addTarget:self action:@selector(noget) forControlEvents:UIControlEventTouchUpInside];
    nogetB.frame = CGRectMake(100, 600, 200, 60);
    [self.view addSubview:nogetB];

}

// 获取焦点
-(void)solo{
    // [AVAudioSession sharedInstance] 当前应用的单例，设置当前应用
    // withOptions:
    NSError *error = nil;
    if ([[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDuckOthers error:&error] == NO){
        NSLog(@"%@",error);
        return;
    }
    error = nil;
    if ([[AVAudioSession sharedInstance] setActive:YES error:&error] == NO){
        NSLog(@"%@",error);
        return;
    }
    if(![self.player isPlaying]){
        [self.player play];
        [self.playBtn setTitle:@"暂停" forState:UIControlStateNormal];
    }
}
// 释放焦点
-(void)noget
{
    if ([self.player isPlaying]){
        [self.player pause];
        [self.playBtn setTitle:@"播放" forState:UIControlStateNormal];
    }
    
    NSError *error = nil;
    // AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation 释放的同时别的app会收到通知，继续播放
    if ([[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error] == NO){
        NSLog(@"%@",error);
        return;
    }
}

-(void)play
{
    if ([self.player isPlaying]){
        [self.playBtn setTitle:@"播放" forState:UIControlStateNormal];
        [self.player pause];
    }else{
        [self.playBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [self.player play];
    }
    NSLog(@"%@",[AVAudioSession sharedInstance].category);
}

-(void)stop
{
    [self.playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [self.player stop];
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    if (player == _player && flag) {
        [self.playBtn setTitle:@"播放" forState:UIControlStateNormal];
    }
}
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    if (player == _player){
        NSLog(@"播放被中断");
    }
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    if (player == _player){
        [self play];
    }
}

@end

