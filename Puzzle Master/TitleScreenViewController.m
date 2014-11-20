//
//  TitleScreenViewController.m
//  Puzzle Master
//
//  Created by Chris Lockwood on 11/10/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import "TitleScreenViewController.h"

@interface TitleScreenViewController ()

@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;

@end

@implementation TitleScreenViewController



#pragma mark - Instantiation

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUp];
}

-(void)setUp{
    
    [self updateHighScoreLabel];
    
}

-(void)updateHighScoreLabel {
    
    // Get documents directory path for Data.plist
    NSArray *allPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [allPaths objectAtIndex:0];
    NSString *plistPath = [documentsDirectoryPath stringByAppendingPathComponent:@"Data.plist"];
    
    // Check to see if the file already exists, if not it copies in the plist from the main bundle
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    if (![fileManager fileExistsAtPath:plistPath]) {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
        [fileManager removeItemAtPath:plistPath error:&error];
        [fileManager copyItemAtPath:bundle toPath:plistPath error:&error];
    }
    
    // Obtain high score from plist and set it to high score label
    NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    NSInteger highScore = [[savedData objectForKey:@"High score"] integerValue];
    
    self.highScoreLabel.text = [NSString stringWithFormat:@"High score: %d", highScore];

}







@end