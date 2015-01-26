//
//  AppDelegate.h
//  Puzzle Master
//
//  Created by Chris Lockwood on 10/23/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) PuzzleView *puzzle;

-(void)setObjectForDelegate:(PuzzleView *)value;

@end

