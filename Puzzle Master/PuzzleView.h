//
//  PuzzleView.h
//  Puzzle Master
//
//  Created by Chris Lockwood on 11/6/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PuzzleViewDelegate;

@interface PuzzleView : UIView

@property (nonatomic, strong) UIImage *puzzleImage;
@property (nonatomic, readonly) NSUInteger widthNum;
@property (nonatomic, readonly) NSUInteger heightNum;

@property (nonatomic, weak) id<PuzzleViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame
              withWidthNum:(NSUInteger)widthNum
             withHeightNum:(NSUInteger)heightNum
                   withImage:(UIImage *)puzzleImage;

-(void)restartPuzzle;
-(void)restartPuzzlewithWidthNum:(NSUInteger)widthNum
                   withHeightNum:(NSUInteger)heightNum
                       withImage:(UIImage *)puzzleImage;

@end

// The PuzzleViewDelegate is alerted with a method when the PuzzleView has been completed
@protocol PuzzleViewDelegate <NSObject>

@optional
-(void)puzzleCompleted;

@end