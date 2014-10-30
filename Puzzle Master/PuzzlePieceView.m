//
//  PuzzlePieceView.m
//  Puzzle Master
//
//  Created by Chris Lockwood on 10/28/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import "PuzzlePieceView.h"

@interface PuzzlePieceView ()

@property (nonatomic) NSUInteger widthIndex;
@property (nonatomic) NSUInteger heightIndex;
@property (nonatomic) NSUInteger widthNum;
@property (nonatomic) NSUInteger heightNum;
@property (nonatomic) NSUInteger *edgeIndicies;

@property (nonatomic) CGPoint oldCenter;

@end

@interface PuzzlePieceView()
//
//@property (nonatomic) NSUInteger widthIndex;
//@property (nonatomic) NSUInteger heightIndex;

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
    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(detectDrag:)]];
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
    
    
    //Still Implementing: Stroke Color Stuff
//    [[UIColor blackColor] setStroke];
//    [path strokeWithBlendMode:kCGBlendModeHue alpha:1];
//    
//    UIBezierPath *strokePath = [path ]
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

// Warning: When The Height does not match the width, the proportion of the curves might be strange
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



#pragma mark - Actions

-(void)detectDrag:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    CGPoint translation = [panGestureRecognizer translationInView:self.superview];
    self.center = CGPointMake(translation.x + self.oldCenter.x,
                              translation.y + self.oldCenter.y);
    
}

// Sets old center upon being touched and moves piece to the front of the subivews in ViewController
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.superview bringSubviewToFront:self];
    
    self.oldCenter = self.center;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

@end
