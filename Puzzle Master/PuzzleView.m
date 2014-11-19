//
//  PuzzleView.m
//  Puzzle Master
//
//  Created by Chris Lockwood on 11/6/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "PuzzleView.h"
#import "PuzzlePieceView.h"

@interface PuzzleView()

// PuzzlePieceView Objects
@property (nonatomic, strong) NSMutableArray *pieces; //of PuzzlePieceViews

// Number of Pieces across Width and Height of Puzzle
@property (nonatomic) NSUInteger widthNum;
@property (nonatomic) NSUInteger heightNum;

// Pixel Width and Height of each Piece
@property (nonatomic) CGFloat pieceWidth;
@property (nonatomic) CGFloat pieceHeight;

// Music Player for Puzzle Actions
@property (nonatomic, strong) AVAudioPlayer *player;

//// Delegate Object
//@property (nonatomic, strong)

@end

@implementation PuzzleView

#pragma mark - Instantiation

-(instancetype)initWithFrame:(CGRect)frame
                withWidthNum:(NSUInteger)widthNum
               withHeightNum:(NSUInteger)heightNum
                   withImage:(UIImage *)puzzleImage{
    self = [super initWithFrame:frame];
    self.widthNum = widthNum;
    self.heightNum = heightNum;
    self.puzzleImage = puzzleImage;

    return self;
}

NSUInteger const DEFAULT_WIDTH_NUM = 4;
NSUInteger const DEFAULT_HEIGHT_NUM = 4;
-(void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.widthNum = DEFAULT_WIDTH_NUM;
    self.heightNum = DEFAULT_HEIGHT_NUM;
}

// Creates PuzzlePieceView subviews after the constraints of the PuzzleView have been set
-(void)layoutSubviews {
    if ([self.pieces count] == 0) {
        [self setUp];
    }
}

-(void)setUp{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    
    [self createPieces];
    [self randomlyMovePieces];
}

/* Creating the PuzzlePieceViews requires the following steps:
    1. Create random array of vertical edeges for the pieces of the puzzle.
    2. Create random array of horizontal edeges for the pieces of the puzzle.
    3. Instantiate each piece with the correct edges
    4. Give each piece a pointer to its neighboring pieces in piece.neighborPieces
*/
-(void)createPieces {
    
    NSUInteger NUMBER_OF_EDGE_TYPES = [PuzzlePieceView numberOfEdgeTypes];
    
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
            
            PuzzlePieceView *piece = [[PuzzlePieceView alloc] initWithFrame:CGRectMake(self.pieceWidth * widthIndex, self.pieceHeight * heightIndex, self.pieceWidth, self.pieceHeight) withWidthIndex:widthIndex withHeightIndex:heightIndex withWidthNum:self.widthNum withHeightNum:self.heightNum withEdgeIndicies:edgeIndicies withPuzzleImage:self.puzzleImage];
            [self addSubview:piece];
            [self.pieces addObject:piece];
            
            [piece addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(detectDrag:)]];
        }
    }
    
    for (NSUInteger heightIndex = 0; heightIndex < self.heightNum; heightIndex++) {
        for (NSUInteger widthIndex = 0; widthIndex < self.widthNum; widthIndex++) {
            PuzzlePieceView *piece = (PuzzlePieceView *)self.pieces[widthIndex + heightIndex * self.widthNum];
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

// Moves each Piece to a Random Location in the Puzzle
-(void)randomlyMovePieces {
    
    NSMutableArray *possibleLocations = [[NSMutableArray alloc]init];
    
    for (NSUInteger heightIndex = 0; heightIndex < self.heightNum; heightIndex++) {
        for (NSUInteger widthIndex = 0; widthIndex < self.widthNum; widthIndex++) {
            [possibleLocations addObject:[NSValue valueWithCGPoint:CGPointMake((widthIndex + .5) * self.pieceWidth, (heightIndex + .5) * self.pieceHeight)]];
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

NSString *DEFAULT_IMAGE_NAME = @"TheWitnessBlossoms";

- (UIImage *)puzzleImage {
    if (!_puzzleImage) {
        _puzzleImage = [UIImage imageNamed:DEFAULT_IMAGE_NAME];
    }
    
    return _puzzleImage;
}

double AMOUNT_OF_SUPERVIEW_HEIGHT_USED = .5;
-(BOOL)horizontal { return (self.frame.size.width > self.frame.size.height); };
// Piece Width will always be determined by the shorter side, so rotation does not change the size of the piece.

-(CGFloat) pieceWidth {
    if (!_pieceWidth) {
    
        if ([self horizontal]) {
            _pieceWidth = self.frame.size.width  * AMOUNT_OF_SUPERVIEW_HEIGHT_USED / self.widthNum;
        } else {
           _pieceWidth = self.frame.size.width / self.widthNum;
        }
    }
    
    return _pieceWidth;
}

-(CGFloat) pieceHeight {
    if (!_pieceHeight) {
        if ([self horizontal]) {
            _pieceHeight = self.frame.size.height / self.heightNum;
        } else {
            _pieceHeight = self.frame.size.height * AMOUNT_OF_SUPERVIEW_HEIGHT_USED / self.heightNum;
        }
    }
    
    return _pieceHeight;
}

-(AVAudioPlayer *)player {
    if (!_player) {
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"Click-Puzzle-Master" ofType:@"mp3"];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        _player.volume = 0.1;
    }
    
    return _player;
}


#pragma mark - Puzzle Functions

-(void)restartPuzzle {
    for (PuzzlePieceView *piece in self.pieces) {
        piece.neighborPieces = nil;
        piece.connectedPieces = nil;
        [piece removeFromSuperview];
    }
    self.pieces = nil;
    self.pieceHeight = 0;
    self.pieceWidth = 0;
    
    [self createPieces];
    [self randomlyMovePieces];
}

-(void)restartPuzzlewithWidthNum:(NSUInteger)widthNum withHeightNum:(NSUInteger)heightNum withImage:(UIImage *)puzzleImage {
    self.widthNum = widthNum;
    self.heightNum = heightNum;
    self.puzzleImage = puzzleImage;
    
    [self restartPuzzle];
}

-(void)checkForCompletion {
    if ([((PuzzlePieceView *)self.pieces[0]).connectedPieces count] == self.widthNum * self.heightNum) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(puzzleCompleted)]) {
            [self.delegate puzzleCompleted];
        }
    }
}



#pragma mark - Puzzle Actions

-(void)detectDrag:(UIPanGestureRecognizer *)panGestureRecognizer {
    PuzzlePieceView *selectedPiece = (PuzzlePieceView *)panGestureRecognizer.view;
    
    CGPoint translation = [panGestureRecognizer translationInView:self];
    [selectedPiece moveWithConnectedPiece:translation];
    
    panGestureRecognizer.cancelsTouchesInView = NO;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        NSInteger oldMatchesNum = [selectedPiece.connectedPieces count];
        [selectedPiece checkForNewMatches];
        [self checkForCompletion];
        
        if (oldMatchesNum < [selectedPiece.connectedPieces count]) {
            [self.player play];
        }
    }
}

@end
