//
//  ViewController.m
//  Puzzle Master
//
//  Created by Chris Lockwood on 10/23/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import "ViewController.h"
#import "PuzzlePieceView.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *pieces; //of PuzzlePieceViews

@end

@implementation ViewController



#pragma mark - Instantiation

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self createPieces];
    [self randomlyMovePieces];
    
}

NSUInteger PIECE_WIDTH = 4;
NSUInteger PIECE_HEIGHT = 4;

double WIDTH_HEIGHT_RATIO = .8;
-(double) pieceWidth { return self.view.frame.size.width / PIECE_WIDTH; }
-(double) pieceHeight { return [self pieceWidth] * WIDTH_HEIGHT_RATIO; }

-(void)createPieces {
    
    // Note: Remeber to change the number of edge types to depend on pieces
    NSUInteger NUMBER_OF_EDGE_TYPES = 4;
    
    NSUInteger verticalEdgeArray[PIECE_WIDTH + 1][PIECE_HEIGHT];
    for (NSUInteger heightIndex = 0; heightIndex < PIECE_HEIGHT; heightIndex++) {
        for (NSUInteger widthIndex = 0; widthIndex < PIECE_WIDTH + 1; widthIndex++) {
            if (widthIndex == 0 || widthIndex == PIECE_WIDTH) {
                verticalEdgeArray[widthIndex][heightIndex] = 0;
            } else {
                verticalEdgeArray[widthIndex][heightIndex] = (arc4random() % NUMBER_OF_EDGE_TYPES) + 1;
            }
        }
    }
    
    NSUInteger horizontalEdgeArray[PIECE_WIDTH][PIECE_HEIGHT + 1];
    for (NSUInteger heightIndex = 0; heightIndex < PIECE_HEIGHT + 1; heightIndex++) {
        for (NSUInteger widthIndex = 0; widthIndex < PIECE_WIDTH; widthIndex++) {
            if (heightIndex == 0 || heightIndex == PIECE_HEIGHT) {
                horizontalEdgeArray[widthIndex][heightIndex] = 0;
            } else {
                horizontalEdgeArray[widthIndex][heightIndex] = (arc4random() % NUMBER_OF_EDGE_TYPES) + 1;
            }
        }
    }
    
    for (NSUInteger heightIndex = 0; heightIndex < PIECE_HEIGHT; heightIndex++) {
        for (NSUInteger widthIndex = 0; widthIndex < PIECE_WIDTH; widthIndex++) {
            NSUInteger edgeIndicies[4] = {horizontalEdgeArray[widthIndex][heightIndex],
                verticalEdgeArray[widthIndex + 1][heightIndex],
                horizontalEdgeArray[widthIndex][heightIndex + 1],
                verticalEdgeArray[widthIndex][heightIndex]};
            
            PuzzlePieceView *piece = [[PuzzlePieceView alloc] initWithFrame:CGRectMake([self pieceWidth]* widthIndex, [self pieceHeight] * heightIndex, [self pieceWidth], [self pieceHeight]) withWidthIndex:widthIndex withHeightIndex:heightIndex withWidthNum:PIECE_WIDTH withHeightNum:PIECE_HEIGHT withEdgeIndicies:edgeIndicies];
            piece.delegate = self;
            [self.view addSubview:piece];
            [self.pieces addObject:piece];
        }
    }
}

-(void)randomlyMovePieces {
    NSMutableArray *possibleLocations = [[NSMutableArray alloc]init];
    
    for (NSUInteger heightIndex = 0; heightIndex < PIECE_HEIGHT; heightIndex++) {
        for (NSUInteger widthIndex = 0; widthIndex < PIECE_WIDTH; widthIndex++) {
            [possibleLocations addObject:[NSValue valueWithCGPoint:CGPointMake((widthIndex + .5) * [self pieceWidth], (heightIndex + .5) * [self pieceHeight])]];
        }
    }
    
    for (PuzzlePieceView *piece in self.pieces) {
        NSUInteger randomIndex = arc4random() % [possibleLocations count];
        
        piece.center = [[possibleLocations objectAtIndex:randomIndex] CGPointValue];
        [possibleLocations removeObjectAtIndex:randomIndex];
    }
}



#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



// Note: Move this to instantiation section
#pragma mark - Setters and Getters

- (NSMutableArray *)pieces {
    if (!_pieces) {
        _pieces = [[NSMutableArray alloc] init];
    }
    
    return _pieces;
}

@end
