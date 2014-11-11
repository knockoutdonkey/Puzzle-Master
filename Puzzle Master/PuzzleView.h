//
//  PuzzleView.h
//  Puzzle Master
//
//  Created by Chris Lockwood on 11/6/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PuzzleView : UIView

@property (nonatomic, strong) UIImage *puzzleImage;
@property (nonatomic, readonly) NSUInteger widthNum;
@property (nonatomic, readonly) NSUInteger heightNum;

-(instancetype)initWithFrame:(CGRect)frame
              withWidthNum:(NSUInteger)widthNum
             withHeightNum:(NSUInteger)heightNum
                   withImage:(UIImage *)puzzleImage;

-(void)restartPuzzle;
-(void)restartPuzzlewithWidthNum:(NSUInteger)widthNum
                   withHeightNum:(NSUInteger)heightNum
                       withImage:(UIImage *)puzzleImage;

@end
