//
//  PuzzleView.m
//  Puzzle Master
//
//  Created by Chris Lockwood on 11/6/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import "PuzzleView.h"
#import "PuzzlePieceView.h"

@interface PuzzleView()

@property (nonatomic, strong) NSMutableArray *pieces; //of PuzzlePieceViews
@property (nonatomic) NSUInteger widthNum;
@property (nonatomic) NSUInteger heightNum;

@end

@implementation PuzzleView

#pragma mark - Instantiation

-(instancetype)initWithFrame:(CGRect)frame withWidthNum:(NSUInteger)widthNum withHeightNum:(NSUInteger)heightNum {
    self = [super initWithFrame:frame];
    self.widthNum = widthNum;
    self.heightNum = heightNum;
    
    [self createPieces];
    [self randomlyMovePieces];
    
    return self;
}

double AMOUNT_OF_HEIGHT_USED = .5;

-(double) pieceWidth { return self.frame.size.width / self.widthNum; }
-(double) pieceHeight { return self.frame.size.height / self.heightNum * AMOUNT_OF_HEIGHT_USED; }

-(void)createPieces {
    
    // Note: Remeber to change the number of edge types to depend on pieces
    NSUInteger NUMBER_OF_EDGE_TYPES = 4;
    
    NSUInteger verticalEdgeArray[self.widthNum + 1][self.heightNum];
    for (NSUInteger heightIndex = 0; heightIndex < self.heightNum; heightIndex++) {
        for (NSUInteger widthIndex = 0; widthIndex < self.widthNum + 1; widthIndex++) {
            if (widthIndex == 0 || widthIndex == self.widthNum) {
                verticalEdgeArray[widthIndex][heightIndex] = 0;
            } else {
                verticalEdgeArray[widthIndex][heightIndex] = (arc4random() % NUMBER_OF_EDGE_TYPES) + 1;
            }
        }
    }
    
    NSUInteger horizontalEdgeArray[self.widthNum][self.heightNum + 1];
    for (NSUInteger heightIndex = 0; heightIndex < self.heightNum + 1; heightIndex++) {
        for (NSUInteger widthIndex = 0; widthIndex < self.widthNum; widthIndex++) {
            if (heightIndex == 0 || heightIndex == self.heightNum) {
                horizontalEdgeArray[widthIndex][heightIndex] = 0;
            } else {
                horizontalEdgeArray[widthIndex][heightIndex] = (arc4random() % NUMBER_OF_EDGE_TYPES) + 1;
            }
        }
    }
    
    for (NSUInteger heightIndex = 0; heightIndex < self.heightNum; heightIndex++) {
        for (NSUInteger widthIndex = 0; widthIndex < self.widthNum; widthIndex++) {
            NSUInteger edgeIndicies[4] = {horizontalEdgeArray[widthIndex][heightIndex],
                verticalEdgeArray[widthIndex + 1][heightIndex],
                horizontalEdgeArray[widthIndex][heightIndex + 1],
                verticalEdgeArray[widthIndex][heightIndex]};
            
            PuzzlePieceView *piece = [[PuzzlePieceView alloc] initWithFrame:CGRectMake([self pieceWidth]* widthIndex, [self pieceHeight] * heightIndex, [self pieceWidth], [self pieceHeight]) withWidthIndex:widthIndex withHeightIndex:heightIndex withWidthNum:self.widthNum withHeightNum:self.heightNum withEdgeIndicies:edgeIndicies];
            piece.delegate = self;
            [self addSubview:piece];
            [self.pieces addObject:piece];
        }
    }
    
    for (NSUInteger heightIndex = 0; heightIndex < self.heightNum; heightIndex++) {
        for (NSUInteger widthIndex = 0; widthIndex < self.widthNum; widthIndex++) {
            PuzzlePieceView *piece = (PuzzlePieceView *)self.pieces[widthIndex + heightIndex * self.heightNum];
            if (heightIndex > 0) {
                [piece.neighborPieces addObject: self.pieces[widthIndex + (heightIndex - 1) * self.widthNum]];
            } else {
                [piece.neighborPieces addObject:piece];
            }
            if (widthIndex < self.widthNum - 1) {
                [piece.neighborPieces addObject: self.pieces[widthIndex + 1 + heightIndex * self.widthNum]];
            } else {
                [piece.neighborPieces addObject:piece];
            }
            if (heightIndex < self.heightNum - 1) {
                [piece.neighborPieces addObject: self.pieces[widthIndex + (heightIndex + 1) * self.widthNum]];
            } else {
                [piece.neighborPieces addObject:piece];
            }
            if (widthIndex > 0) {
                [piece.neighborPieces addObject: self.pieces[widthIndex - 1 + heightIndex * self.widthNum]];
            } else {
                [piece.neighborPieces addObject:piece];
            }
        }
    }
}

-(void)randomlyMovePieces {
    NSMutableArray *possibleLocations = [[NSMutableArray alloc]init];
    
    for (NSUInteger heightIndex = 0; heightIndex < self.heightNum; heightIndex++) {
        for (NSUInteger widthIndex = 0; widthIndex < self.widthNum; widthIndex++) {
            [possibleLocations addObject:[NSValue valueWithCGPoint:CGPointMake((widthIndex + .5) * [self pieceWidth], (heightIndex + .5) * [self pieceHeight])]];
        }
    }
    
    for (PuzzlePieceView *piece in self.pieces) {
        NSUInteger randomIndex = arc4random() % [possibleLocations count];
        
        piece.center = [[possibleLocations objectAtIndex:randomIndex] CGPointValue];
        [possibleLocations removeObjectAtIndex:randomIndex];
    }
}



#pragma mark - Setters and Getters

- (NSMutableArray *)pieces {
    if (!_pieces) {
        _pieces = [[NSMutableArray alloc] init];
    }
    
    return _pieces;
}



#pragma mark - Puzzle Functions

-(void)restartPuzzle {
    self.pieces = nil;
    
    [self createPieces];
    [self randomlyMovePieces];
}

@end
