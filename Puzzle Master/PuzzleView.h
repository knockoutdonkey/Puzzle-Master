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
@property (nonatomic, readonly) NSInteger widthNum;
@property (nonatomic, readonly) NSInteger heightNum;

@property (nonatomic, weak) id<PuzzleViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame
              withWidthNum:(NSInteger)widthNum
             withHeightNum:(NSInteger)heightNum
                   withImage:(UIImage *)puzzleImage;

-(void)restartPuzzle;
-(void)restartPuzzlewithWidthNum:(NSInteger)widthNum
                   withHeightNum:(NSInteger)heightNum
                       withImage:(UIImage *)puzzleImage;

@end

// The PuzzleViewDelegate is alerted with a method when the PuzzleView has been completed
@protocol PuzzleViewDelegate <NSObject>

@optional
-(void)puzzleCompleted;

@end