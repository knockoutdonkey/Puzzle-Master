//
//  ViewController.h
//  Puzzle Master
//
//  Created by Chris Lockwood on 10/23/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

-(void)createNewPuzzleWithWidthNum:(NSUInteger)widthNum
                     withHeightNum:(NSUInteger)heightNum
                         withImage:(UIImage *)image;

@end

