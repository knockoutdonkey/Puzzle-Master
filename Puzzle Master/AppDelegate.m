//
//  AppDelegate.m
//  Puzzle Master
//
//  Created by Chris Lockwood on 10/23/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@end

@implementation AppDelegate
@synthesize puzzle;

-(void)setObjectForDelegate:(PuzzleView *)value{
    puzzle = value;
    //use value obj or set it to other variable
}

-(void)applicationWillTerminate:(UIApplication *)application{
    NSArray *allpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentspath = [allpaths objectAtIndex:0];
    NSString *savfilepath = [documentspath stringByAppendingPathComponent:@"Puzzle.plist"];
    [NSKeyedArchiver archiveRootObject:puzzle toFile:savfilepath];
}

-(void)applicationDidEnterBackground:(UIApplication *)application{
    NSArray *allpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentspath = [allpaths objectAtIndex:0];
    NSString *savfilepath = [documentspath stringByAppendingPathComponent:@"Puzzle.plist"];
    [NSKeyedArchiver archiveRootObject:puzzle toFile:savfilepath];
}

@end

