//
//  ViewController.h
//  Puzzle Master
//
//  Created by Chris Lockwood on 10/23/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleView.h"

@interface ViewController : UIViewController <PuzzleViewDelegate>

-(void)createNewPuzzleWithWidthNum:(NSInteger)widthNum
                     withHeightNum:(NSInteger)heightNum
                         withImage:(UIImage *)image;

@end

