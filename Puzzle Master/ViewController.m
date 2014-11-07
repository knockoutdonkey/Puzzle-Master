//
//  ViewController.m
//  Puzzle Master
//
//  Created by Chris Lockwood on 10/23/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//


#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "ViewController.h"
#import "PuzzleView.h"

@interface ViewController ()

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) PuzzleView *puzzle;

@end

@implementation ViewController



#pragma mark - Instantiation

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.puzzle = [[PuzzleView alloc] initWithFrame:self.view.frame withWidthNum:4 withHeightNum:4];
    [self.view addSubview:self.puzzle];
    
    // [self startMusicLoop];
    
}

-(void)startMusicLoop {
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"Megaman_2_title_theme" ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    self.player.numberOfLoops = -1;
    self.player.volume = 0.5;
    
    [self.player play];
}



#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
