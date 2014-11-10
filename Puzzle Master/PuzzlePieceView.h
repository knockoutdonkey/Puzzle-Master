//
//  PuzzlePieceView.h
//  Puzzle Master
//
//  Created by Chris Lockwood on 10/28/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PuzzlePieceView : UIButton

@property (nonatomic, readonly) NSUInteger widthIndex;
@property (nonatomic, readonly) NSUInteger heightIndex;
@property (nonatomic, readonly) NSUInteger widthNum;
@property (nonatomic, readonly) NSUInteger heightNum;
@property (nonatomic, readonly) NSUInteger *edgeIndicies;

@property (nonatomic,strong) id delegate;

// Instantiation Methods
-(instancetype)initWithFrame:(CGRect)frame
              withWidthIndex:(NSUInteger)widthIndex
             withHeightIndex:(NSUInteger)heightIndex
                withWidthNum:(NSUInteger)widthNum
               withHeightNum:(NSUInteger)heightNum
            withEdgeIndicies:(NSUInteger *)edgeIndicies;

// Matching Methods
-(NSUInteger)checkIfMatched:(PuzzlePieceView *)piece;
-(void)connectPiece:(PuzzlePieceView *)piece withLocation:(NSUInteger)locationIndex;

// Puzzle Piece Information Methods
+(NSUInteger)numberOfEdgeTypes;

@end
