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
#import "SettingsViewController.h"

@interface ViewController ()

// Puzzle Game Object
@property (weak, nonatomic) IBOutlet PuzzleView *puzzle;

// PUZButton Objects on Bottem of Screen (all treated as UIButtons)
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *timerButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

// Timer Object
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger timeElapsed;

// Music Player Object
@property (nonatomic, strong) AVAudioPlayer *musicPlayer;

// HighScore
@property (nonatomic) NSInteger highScore;

@end

@implementation ViewController



#pragma mark - Instantiation

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.puzzle.delegate = self;
    
    [self createTimer];
    [self getHighScore];
    [self setNeedsStatusBarAppearanceUpdate];
    // [self startMusicLoop];
    
}

-(void)startMusicLoop {
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"Megaman_2_title_theme" ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    self.musicPlayer.numberOfLoops = -1;
    self.musicPlayer.volume = 0.5;
    
    [self.musicPlayer play];
}

-(void)createTimer {
    self.timer = [NSTimer timerWithTimeInterval: 1.0
                                                  target:self
                                                selector:@selector(updateTimer)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
    
    [self.timerButton setTitle:@"0:00" forState:UIControlStateNormal];
    
    self.timeElapsed = 0;
}

-(void)getHighScore {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.highScore = [(NSNumber *)[dictionary objectForKey:@"High score"] integerValue];
    
}

#pragma mark - Actions

- (IBAction)resetButtonPushed:(id)sender {
    [self showResetWarning];
}

-(void)showResetWarning {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"WARNING:" message:@"Are you sure you want to restart your puzzle?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *restartAction = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.puzzle restartPuzzle];
            [self restartTimer];
        }];
    [alert addAction:restartAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)createNewPuzzleWithWidthNum:(NSUInteger)widthNum
                     withHeightNum:(NSUInteger)heightNum
                         withImage:(UIImage *)image {
    [self.puzzle restartPuzzlewithWidthNum:widthNum withHeightNum:heightNum withImage:image];
    [self restartTimer];
}



#pragma mark - PuzzleViewDelegate Methods

-(void)puzzleCompleted {
    [self pauseTimer];
}



#pragma mark - Timer Interaction

-(void)updateTimer {
    _timeElapsed++;
    
    [self.timerButton setTitle:[NSString stringWithFormat:@"%d:%02d", _timeElapsed / 60, _timeElapsed % 60] forState:UIControlStateNormal];
}

-(void)restartTimer {
    [self.timer invalidate];
    [self createTimer];
}

-(void)pauseTimer {
    [self.timer invalidate];
}



#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Settings"]) {
        if ([segue.destinationViewController isKindOfClass:[SettingsViewController class]]) {
            SettingsViewController *svc = (SettingsViewController *) segue.destinationViewController;
            [svc useOldWidthNum:self.puzzle.widthNum heightNum:self.puzzle.heightNum image:self.puzzle.puzzleImage];
        }
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
