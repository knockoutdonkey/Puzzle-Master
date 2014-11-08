//
//  PuzzlePieceView.m
//  Puzzle Master
//
//  Created by Chris Lockwood on 10/28/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//
//  This class iplements the PuzzlePieceView UI object.

#import <AVFoundation/AVAudioPlayer.h>

#import "PuzzlePieceView.h"

@interface PuzzlePieceView ()

@property (nonatomic) NSUInteger widthIndex;
@property (nonatomic) NSUInteger heightIndex;
@property (nonatomic) NSUInteger widthNum;
@property (nonatomic) NSUInteger heightNum;
@property (nonatomic) NSUInteger *edgeIndicies;

@property (nonatomic) CGPoint oldCenter;

@end

@implementation PuzzlePieceView



#pragma mark - Instantiation

-(void)awakeFromNib {
    self.widthIndex = 0;
    self.heightIndex = 0;
    
    [self setUp];
}

-(instancetype)initWithFrame:(CGRect)frame
              withWidthIndex:(NSUInteger)widthIndex
             withHeightIndex:(NSUInteger)heightIndex
                withWidthNum:(NSUInteger)widthNum
               withHeightNum:(NSUInteger)heightNum
            withEdgeIndicies:(NSUInteger *)edgeIndicies {
    
    self = [super initWithFrame:frame];
    
    self.widthIndex = widthIndex;
    self.heightIndex = heightIndex;
    self.widthNum = widthNum;
    self.heightNum = heightNum;
    self.edgeIndicies = edgeIndicies;
    
    [self setUp];
    
    return self;
}

-(void)setUp {
    [self displayPuzzlePieceImage];
    // [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(detectDrag:)]];
}

-(void)displayPuzzlePieceImage {
    CALayer *contentLayer = [CALayer layer];
    [contentLayer setFrame:CGRectMake(self.widthIndex * -1.0 * self.frame.size.width,
                                      self.heightIndex * -1.0 * self.frame.size.height,
                                      self.frame.size.width * self.widthNum,
                                      self.frame.size.height * self.heightNum)];
    
    CAShapeLayer *mask = [CAShapeLayer layer];
    
    //This UIBezierPath determines the shape of the puzzle piece
    UIBezierPath *path = [self createPath];
    
    mask.path = [path CGPath];
    
    [contentLayer setContents:(id)[[UIImage imageNamed:@"TheWitnessBlossoms"] CGImage]];
    [contentLayer setMask:mask];
    
    [[self layer]addSublayer:contentLayer];
}

-(UIBezierPath *)createPath {
    
    // Each point is a corner of the puzzle piece, starting from the topleft and going alphebeticaly clockwise
    CGPoint pointA = CGPointMake(self.widthIndex * self.frame.size.width,
                                 self.heightIndex * self.frame.size.height);
    CGPoint pointB = CGPointMake(self.widthIndex * self.frame.size.width + self.frame.size.width,
                                 self.heightIndex * self.frame.size.height);
    CGPoint pointC = CGPointMake(self.widthIndex * self.frame.size.width + self.frame.size.width,
                                 self.heightIndex * self.frame.size.height + self.frame.size.height);
    CGPoint pointD = CGPointMake(self.widthIndex * self.frame.size.width,
                                 self.heightIndex * self.frame.size.height + self.frame.size.height);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:pointA];
    
    // Create the path between each corner of the puzzle piece
    [self puzzleEdgeToPath:path withIndex:self.edgeIndicies[0] withStartingPoint:pointA withEndPoint:pointB];
    [self puzzleEdgeToPath:path withIndex:self.edgeIndicies[1] withStartingPoint:pointB withEndPoint:pointC];
    path = [path bezierPathByReversingPath];
    [self puzzleEdgeToPath:path withIndex:self.edgeIndicies[3] withStartingPoint:pointA withEndPoint:pointD];
    [self puzzleEdgeToPath:path withIndex:self.edgeIndicies[2] withStartingPoint:pointD withEndPoint:pointC];
    
    return path;
}

/* Warning: When The Height does not match the width, the proportion of the curves might be strange. If you want to implement more edge types, make sure to also increase the return value of the numberOfEdgeTypes method */

-(UIBezierPath *)puzzleEdgeToPath:(UIBezierPath *)path
                        withIndex:(NSUInteger)pathIndex
                withStartingPoint:(CGPoint)startPoint
                     withEndPoint:(CGPoint)endPoint {
    switch (pathIndex) {
           
        //
        // Curve 1: Rounded Curve Downward or Left
        //
        case 1: {
            float CURVE_STRENGTH = .25;
            
            CGPoint controlPoint1 = CGPointMake(startPoint.x + self.frame.size.width * CURVE_STRENGTH, startPoint.y + self.frame.size.height * CURVE_STRENGTH);
            CGPoint controlPoint2 = CGPointMake(endPoint.x - self.frame.size.width * CURVE_STRENGTH, endPoint.y + self.frame.size.height * CURVE_STRENGTH);
            
            BOOL horizontal = (startPoint.y == endPoint.y);
            if (!horizontal) {
                controlPoint1 = [self rotatePoint:controlPoint1 aroundPoint:startPoint];
                controlPoint2 = [self rotatePoint:controlPoint2 aroundPoint:endPoint];
            }
            
            [path addCurveToPoint:endPoint
                    controlPoint1:controlPoint1
                    controlPoint2:controlPoint2];
            
            break;
        }
           
        //
        // Curve 2: Inverse Rounded Curve Upward or Right (Inversion of Curve 1)
        //
        case 2: {
            float CURVE_STRENGTH = .25;
            
            CGPoint controlPoint1 = CGPointMake(startPoint.x + self.frame.size.width * CURVE_STRENGTH, startPoint.y + self.frame.size.height * CURVE_STRENGTH);
            CGPoint controlPoint2 = CGPointMake(endPoint.x - self.frame.size.width * CURVE_STRENGTH, endPoint.y + self.frame.size.height * CURVE_STRENGTH);
            
            BOOL horizontal = (startPoint.y == endPoint.y);
            if (!horizontal) {
                controlPoint1 = [self rotatePoint:controlPoint1 aroundPoint:startPoint];
                controlPoint2 = [self rotatePoint:controlPoint2 aroundPoint:endPoint];
            }
            
            [path addCurveToPoint:endPoint
                    controlPoint1:controlPoint1
                    controlPoint2:controlPoint2];
            
            break;
        }
            
        //
        // Curve 3: Standard Puzzle Piece Shape
        //
        case 3: {
            
            CGPoint pointBeforeBump = CGPointMake((startPoint.x + endPoint.x) / 2 - (startPoint.x - endPoint.x) / 6, (startPoint.y + endPoint.y) / 2 - (startPoint.y - endPoint.y) / 6);
            CGPoint bumpCenter = CGPointMake((startPoint.x + endPoint.x) / 2, (startPoint.y + endPoint.y) / 2);
            CGPoint pointAfterBump = endPoint;
            
            [path addLineToPoint:pointBeforeBump];
            
            
            CGFloat bumpRadius = (startPoint.x - endPoint.x) / 6 + (startPoint.y - endPoint.y) / 6;
            CGFloat startAngle = 0.0;
            CGFloat endAngle = 3.1459;
            BOOL horizontal = (startPoint.y == endPoint.y);
            if (!horizontal) {
                bumpRadius = (startPoint.x - endPoint.x) / 6 + (startPoint.y - endPoint.y) / 6;
                startAngle = 3.1459 / 2;
                endAngle = 3 * 3.1459 / 2;
            }
            [path addArcWithCenter:bumpCenter radius:bumpRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
            
            [path addLineToPoint:pointAfterBump];
            
            break;
        }
            
        //
        // Curve 4: Inverse Standard Puzzle Piece Shape (Inversion of Curve 3)
        //
        case 4: {
            
            CGPoint pointBeforeBump = CGPointMake((startPoint.x + endPoint.x) / 2 - (startPoint.x - endPoint.x) / 6, (startPoint.y + endPoint.y) / 2 - (startPoint.y - endPoint.y) / 6);
            CGPoint bumpCenter = CGPointMake((startPoint.x + endPoint.x) / 2, (startPoint.y + endPoint.y) / 2);
            CGPoint pointAfterBump = endPoint;
            
            [path addLineToPoint:pointBeforeBump];
            
            
            CGFloat bumpRadius = (startPoint.x - endPoint.x) / 6 + (startPoint.y - endPoint.y) / 6;
            CGFloat startAngle = 0.0;
            CGFloat endAngle = 3.1459;
            BOOL horizontal = (startPoint.y == endPoint.y);
            if (!horizontal) {
                bumpRadius = (startPoint.x - endPoint.x) / 6 + (startPoint.y - endPoint.y) / 6;
                startAngle = 3.1459 / 2;
                endAngle = 3 * 3.1459 / 2;
            }
            [path addArcWithCenter:bumpCenter radius:bumpRadius startAngle:startAngle endAngle:endAngle clockwise:NO];
            
            [path addLineToPoint:pointAfterBump];
            
            break;
        }
            
        //
        // Curve 0: Default Straight Line
        //
        default: {
            [path addLineToPoint:endPoint];
            
            break;
        }
    }
    
    return path;
}

-(CGPoint)rotatePoint:(CGPoint)rotatingPoint aroundPoint:(CGPoint)pivotPoint {
    CGAffineTransform moveToOrigin = CGAffineTransformMakeTranslation(-pivotPoint.x, -pivotPoint.y);
    CGAffineTransform rotate = CGAffineTransformMakeRotation(3.1459 / 2);
    CGAffineTransform moveBack = CGAffineTransformInvert(moveToOrigin);
    
    CGAffineTransform transfrom = CGAffineTransformConcat(CGAffineTransformConcat(moveToOrigin, rotate), moveBack);
    
    return CGPointApplyAffineTransform(rotatingPoint, transfrom);
}

+(NSUInteger)numberOfEdgeTypes {
    return 4;
}



#pragma mark - Setters and Getter


-(NSSet *)connectedPieces {
    if (!_connectedPieces) {
        _connectedPieces = [NSSet setWithObject:self];
    }
    return _connectedPieces;
}

-(NSMutableArray *)neighborPieces {
    if (!_neighborPieces) {
        _neighborPieces = [NSMutableArray array];
    }
    
    return _neighborPieces;
}



#pragma mark - Matching Methods

double MARGIN_OF_MATCHING_ERROR = .3;

-(CGPoint) neighborPointUp { return CGPointMake(self.center.x, self.center.y - self.frame.size.height); }
-(CGPoint) neighborPointRight { return CGPointMake(self.center.x  + self.frame.size.width, self.center.y); }
-(CGPoint) neighborPointDown { return CGPointMake(self.center.x, self.center.y + self.frame.size.height); }
-(CGPoint) neighborPointLeft { return CGPointMake(self.center.x  - self.frame.size.width, self.center.y); }

-(NSUInteger)checkIfMatched:(PuzzlePieceView *)piece withLocation:(NSUInteger)locationIndex {
    
    CGRect bounds = CGRectMake(piece.center.x - piece.frame.size.width * MARGIN_OF_MATCHING_ERROR / 2,  piece.center.y - piece.frame.size.height * MARGIN_OF_MATCHING_ERROR / 2, piece.frame.size.width * MARGIN_OF_MATCHING_ERROR, piece.frame.size.height * MARGIN_OF_MATCHING_ERROR);

    CGPoint neighborPoint = [@[[NSValue valueWithCGPoint:[self neighborPointUp]],
                               [NSValue valueWithCGPoint:[self neighborPointRight]],
                               [NSValue valueWithCGPoint:[self neighborPointDown]],
                               [NSValue valueWithCGPoint:[self neighborPointLeft]]][locationIndex] CGPointValue];
    if (CGRectContainsPoint(bounds, neighborPoint)) {
        return YES;
    }
    return NO;
}

-(void)connectPiece:(PuzzlePieceView *)piece withLocation:(NSUInteger)locationIndex {
    
    CGPoint neighborPoint = [@[[NSValue valueWithCGPoint:[self neighborPointUp]],
                               [NSValue valueWithCGPoint:[self neighborPointRight]],
                               [NSValue valueWithCGPoint:[self neighborPointDown]],
                               [NSValue valueWithCGPoint:[self neighborPointLeft]]][locationIndex] CGPointValue];
    
    CGPoint translation = CGPointMake(neighborPoint.x - piece.center.x, neighborPoint.y - piece.center.y);
    
    for (PuzzlePieceView *movingPiece in piece.connectedPieces) {
        movingPiece.center = CGPointMake(translation.x + movingPiece.center.x,
                                         translation.y + movingPiece.center.y);
    }
    
    self. connectedPieces = [self.connectedPieces setByAddingObjectsFromSet:piece.connectedPieces];
    
    for (PuzzlePieceView *connectedPiece in self.connectedPieces) {
        connectedPiece.connectedPieces = self.connectedPieces;
    }

}



#pragma mark - Movement Methods

-(void)moveWithConnectedPiece:(CGPoint)translation {
    for (PuzzlePieceView *piece in self.connectedPieces) {
        [piece movePiece:translation];
    }
}

-(void)movePiece:(CGPoint)translation {
    self.center = CGPointMake(translation.x + self.oldCenter.x,
                              translation.y + self.oldCenter.y);
}

-(void)checkForNewMatches {
    for (PuzzlePieceView *connectedPiece in self.connectedPieces) {
        for (NSUInteger edgeIndex = 0; edgeIndex < 4; edgeIndex ++) {
            PuzzlePieceView *neighborPiece = (PuzzlePieceView *)connectedPiece.neighborPieces[edgeIndex];
            
            if ([connectedPiece checkIfMatched:neighborPiece withLocation:edgeIndex]) {
                [connectedPiece connectPiece:neighborPiece withLocation:edgeIndex];
            }
        }
    }
}

// Sets old center upon being touched and moves piece and all connected pieces to the front of the subivews in the Superview
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self selectPiece];
}

-(void)selectPiece {
    for (PuzzlePieceView *piece in self.connectedPieces) {
        [piece.superview bringSubviewToFront:piece];
        [piece recenter];
    }
}

-(void)recenter {
    self.oldCenter = self.center;
}



@end
