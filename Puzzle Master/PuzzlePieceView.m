//
//  PuzzlePieceView.m
//  Puzzle Master
//
//  Created by Chris Lockwood on 10/28/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//
//  This class iplements the PuzzlePieceView UI object.

#import "PuzzlePieceView.h"

@interface PuzzlePieceView ()

@property (nonatomic) NSUInteger widthIndex;
@property (nonatomic) NSUInteger heightIndex;
@property (nonatomic) NSUInteger widthNum;
@property (nonatomic) NSUInteger heightNum;
@property (nonatomic) NSUInteger *edgeIndicies;
@property (nonatomic, strong) UIImage *puzzleImage;

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
            withEdgeIndicies:(NSUInteger *)edgeIndicies
             withPuzzleImage:(UIImage *)puzzleImage{
    
    self = [super initWithFrame:frame];
    
    self.widthIndex = widthIndex;
    self.heightIndex = heightIndex;
    self.widthNum = widthNum;
    self.heightNum = heightNum;
    self.edgeIndicies = edgeIndicies;
    self.puzzleImage = puzzleImage;
    
    [self setUp];
    
    return self;
}

-(void)setUp {
    [self displayPuzzlePieceImage];
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
    
    mask.path = path.CGPath;
    
    contentLayer.contents = (id)[self.puzzleImage CGImage];
    contentLayer.mask = mask;
    [[self layer]addSublayer:contentLayer];
    
//    Note: Can't add a shadow to each piece without taking a big hit to framerate
//
//    CAShapeLayer *shadowLayer = [CAShapeLayer layer];
//    shadowLayer.position = CGPointMake(-self.frame.origin.x, -self.frame.origin.y);
//    shadowLayer.shadowColor = [[UIColor blackColor] CGColor];
//    shadowLayer.shadowPath = [path CGPath];
//    shadowLayer.shadowOffset = CGSizeMake(-1, 1);
//    shadowLayer.shadowOpacity = 0.5;
//    shadowLayer.shouldRasterize = YES;
//    shadowLayer.rasterizationScale = [UIScreen mainScreen].scale;
//    self.layer.shadowOpacity = 0.5;
//    
//    [[self layer]addSublayer:shadowLayer];
    
    [[self layer]addSublayer:contentLayer];
    
    CAShapeLayer *outlineLayer = [CAShapeLayer layer];
    outlineLayer.position = CGPointMake(-self.frame.origin.x, -self.frame.origin.y);
    outlineLayer.lineWidth = 1;
    outlineLayer.strokeColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:.2] CGColor];
    outlineLayer.fillColor = [[UIColor clearColor] CGColor];
    outlineLayer.path = [path CGPath];
    
    [[self layer]addSublayer:outlineLayer];
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
    
    BOOL horizontal = (startPoint.y == endPoint.y);
    
    switch (pathIndex) {
           
        //
        // Curve 1: Rounded Curve Downward or Left
        //
        case 1: {
            float CURVE_STRENGTH = .25;
            
            CGPoint controlPoint1 = CGPointMake(startPoint.x + self.frame.size.width * CURVE_STRENGTH, startPoint.y + self.frame.size.height * CURVE_STRENGTH);
            CGPoint controlPoint2 = CGPointMake(endPoint.x - self.frame.size.width * CURVE_STRENGTH, endPoint.y + self.frame.size.height * CURVE_STRENGTH);
            
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
            
            CGPoint pointBeforeBump = CGPointMake((startPoint.x + endPoint.x) / 2 + (startPoint.x - endPoint.x) / 6,
                                                  (startPoint.y + endPoint.y) / 2 + (startPoint.y - endPoint.y) / 6);
            CGPoint bumpCenter = CGPointMake((startPoint.x + endPoint.x) / 2,
                                             (startPoint.y + endPoint.y) / 2);
            CGPoint pointAfterBump = endPoint;

            CGFloat bumpRadius = (startPoint.x - endPoint.x) / 6 + (startPoint.y - endPoint.y) / 6;
            CGFloat startAngle = 0.0;
            CGFloat endAngle = 3.1459;
            
            if (!horizontal) {
                startAngle = 3.1459 / 2;
                endAngle = 3 * 3.1459 / 2;
            }
            
            
            [path addLineToPoint:pointBeforeBump];
            [path addArcWithCenter:bumpCenter radius:bumpRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
            [path addLineToPoint:pointAfterBump];
            
            break;
        }
            
        //
        // Curve 4: Inverse Standard Puzzle Piece Shape (Inversion of Curve 3)
        //
        case 4: {
            
            CGPoint pointBeforeBump = CGPointMake((startPoint.x + endPoint.x) / 2 + (startPoint.x - endPoint.x) / 6,
                                                  (startPoint.y + endPoint.y) / 2 + (startPoint.y - endPoint.y) / 6);
            CGPoint bumpCenter = CGPointMake((startPoint.x + endPoint.x) / 2, (startPoint.y + endPoint.y) / 2);
            CGPoint pointAfterBump = endPoint;
            
            CGFloat bumpRadius = (startPoint.x - endPoint.x) / 6 + (startPoint.y - endPoint.y) / 6;
            CGFloat startAngle = 0.0;
            CGFloat endAngle = 3.1459;
            
            if (!horizontal) {
                bumpRadius = (startPoint.x - endPoint.x) / 6 + (startPoint.y - endPoint.y) / 6;
                startAngle = 3.1459 / 2;
                endAngle = 3 * 3.1459 / 2;
            }
            
            [path addLineToPoint:pointBeforeBump];
            [path addArcWithCenter:bumpCenter radius:bumpRadius startAngle:startAngle endAngle:endAngle clockwise:NO];
            [path addLineToPoint:pointAfterBump];
            
            break;
        }
        
        //
        // Curve 5: Sharp Wiggly Line Puzzle Piece Shape
        //
        case 5: {
            CGPoint midPoint = CGPointMake((startPoint.x + endPoint.x) / 2, (startPoint.y + endPoint.y) / 2);
            
            CGFloat length = (startPoint.x - endPoint.x) + (startPoint.y - endPoint.y);
            CGFloat BUMP_SIZE = .1;

            CGPoint preMidControlPoint = CGPointMake(midPoint.x - length * BUMP_SIZE, midPoint.y - length * BUMP_SIZE);
            CGPoint postMidControlPoint = CGPointMake(midPoint.x + length * BUMP_SIZE, midPoint.y + length * BUMP_SIZE);
            
            [path addCurveToPoint:midPoint
                    controlPoint1:preMidControlPoint
                    controlPoint2:preMidControlPoint];
            [path addCurveToPoint:endPoint
                    controlPoint1:postMidControlPoint
                    controlPoint2:postMidControlPoint];
            
            break;
        }
            
        //
        // Curve 6: Inverse Sharp Wiggly Line (Inversion of Curve 5)
        //
        case 6: {
            CGPoint midPoint = CGPointMake((startPoint.x + endPoint.x) / 2, (startPoint.y + endPoint.y) / 2);
            
            CGFloat length = (startPoint.x - endPoint.x) + (startPoint.y - endPoint.y);
            CGFloat BUMP_SIZE = .1;
            
            CGPoint preMidControlPoint = CGPointMake(midPoint.x + length * BUMP_SIZE, midPoint.y - length * BUMP_SIZE);
            CGPoint postMidControlPoint = CGPointMake(midPoint.x - length * BUMP_SIZE, midPoint.y + length * BUMP_SIZE);
            
            [path addCurveToPoint:midPoint
                    controlPoint1:preMidControlPoint
                    controlPoint2:preMidControlPoint];
            [path addCurveToPoint:endPoint
                    controlPoint1:postMidControlPoint
                    controlPoint2:postMidControlPoint];
            
            break;
        }
            
        //
        // Curve 7: Curvy Puzzle Piece Shape
        //
        case 7: {
            
            CGPoint firstMidPoint = CGPointMake((2 * startPoint.x + endPoint.x) / 3, (2 * startPoint.y + endPoint.y) / 3);
            CGPoint secondMidPoint = CGPointMake((startPoint.x + 2 * endPoint.x) / 3, (startPoint.y + 2 * endPoint.y) / 3);
            
            CGFloat length = self.frame.size.height + self.frame.size.height;
            CGFloat BUMP_SIZE = .08;
            CGFloat directionalModifier = horizontal ? 1 : -1;
            
            CGPoint firstPreControlPoint = CGPointMake(firstMidPoint.x + length * BUMP_SIZE, firstMidPoint.y + length * BUMP_SIZE);
            CGPoint firstPostControlPoint = CGPointMake(firstMidPoint.x - length * BUMP_SIZE, firstMidPoint.y - length * BUMP_SIZE);
            
            CGPoint secondPreControlPoint = CGPointMake(secondMidPoint.x + length * BUMP_SIZE * directionalModifier, secondMidPoint.y - length * BUMP_SIZE * directionalModifier);
            CGPoint secondPostControlPoint = CGPointMake(secondMidPoint.x - length * BUMP_SIZE * directionalModifier, secondMidPoint.y + length * BUMP_SIZE * directionalModifier);
            
            [path addCurveToPoint:firstMidPoint
                    controlPoint1:firstMidPoint
                    controlPoint2:firstPreControlPoint];
            [path addCurveToPoint:secondMidPoint
                    controlPoint1:firstPostControlPoint
                    controlPoint2:secondPreControlPoint];
            [path addCurveToPoint:endPoint
                    controlPoint1:secondPostControlPoint
                    controlPoint2:secondMidPoint];
            
            break;
        }
            
        //
        // Curve 8: Inverse Curvy Puzzle Piece Shape (Inversion of Curve 7)
        //
        case 8: {
            
            CGPoint firstMidPoint = CGPointMake((2 * startPoint.x + endPoint.x) / 3, (2 * startPoint.y + endPoint.y) / 3);
            CGPoint secondMidPoint = CGPointMake((startPoint.x + 2 * endPoint.x) / 3, (startPoint.y + 2 * endPoint.y) / 3);
            
            CGFloat length = self.frame.size.height + self.frame.size.height;
            CGFloat BUMP_SIZE = .1;
            CGFloat directionalModifier = horizontal ? 1 : -1;
            
            CGPoint firstPreControlPoint = CGPointMake(firstMidPoint.x + length * BUMP_SIZE * directionalModifier, firstMidPoint.y - length * BUMP_SIZE * directionalModifier);
            CGPoint firstPostControlPoint = CGPointMake(firstMidPoint.x - length * BUMP_SIZE * directionalModifier, firstMidPoint.y + length * BUMP_SIZE * directionalModifier);
            
            CGPoint secondPreControlPoint = CGPointMake(secondMidPoint.x + length * BUMP_SIZE, secondMidPoint.y + length * BUMP_SIZE);
            CGPoint secondPostControlPoint = CGPointMake(secondMidPoint.x - length * BUMP_SIZE, secondMidPoint.y - length * BUMP_SIZE);
            
            [path addCurveToPoint:firstMidPoint
                    controlPoint1:firstMidPoint
                    controlPoint2:firstPreControlPoint];
            [path addCurveToPoint:secondMidPoint
                    controlPoint1:firstPostControlPoint
                    controlPoint2:secondPreControlPoint];
            [path addCurveToPoint:endPoint
                    controlPoint1:secondPostControlPoint
                    controlPoint2:secondMidPoint];
            
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
    return 8;
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

double MARGIN_OF_MATCHING_ERROR = .4;

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
