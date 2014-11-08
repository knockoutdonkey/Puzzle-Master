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
#import "ResetButton.h"
#import "SettingsButton.h"

@interface ViewController ()

@property (nonatomic, strong) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet PuzzleView *puzzle;
@property (weak, nonatomic) IBOutlet ResetButton *resetButton;
@property (weak, nonatomic) IBOutlet SettingsButton *settingsButton;

@end

@implementation ViewController



#pragma mark - Instantiation

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // [self startMusicLoop];
    
    [self setBackgroundImage];
    
}

-(void)startMusicLoop {
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"Megaman_2_title_theme" ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    self.player.numberOfLoops = -1;
    self.player.volume = 0.5;
    
    [self.player play];
}

-(void)setBackgroundImage {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WoodenBackground"]];
    [imageView setFrame:self.view.frame];
    
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
}



#pragma mark - Actions

- (IBAction)resetButtonPushed:(id)sender {
    [self showResetWarning];
}

-(void)showResetWarning {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"WARNING:" message:@"Are you sure you want to restart your puzzle?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *restartAction = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.puzzle restartPuzzle];
        }];
    [alert addAction:restartAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}



#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
