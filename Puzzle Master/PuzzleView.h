//
//  PuzzleView.h
//  Puzzle Master
//
//  Created by Chris Lockwood on 11/6/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PuzzleView : UIView

-(instancetype)initWithFrame:(CGRect)frame
              withWidthNum:(NSUInteger)widthNum
             withHeightNum:(NSUInteger)heightNum;

-(void)restartPuzzle;

@end
