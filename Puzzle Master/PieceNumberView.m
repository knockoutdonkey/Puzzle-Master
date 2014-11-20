//
//  PieceNumberView.m
//  Puzzle Master
//
//  Created by Chris Lockwood on 11/8/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import "PieceNumberView.h"
#import "NumberScrollView.h"

@interface PieceNumberView() <UIScrollViewDelegate>

// Subviews
@property (nonatomic, strong) NumberScrollView *bottemNSV;
@property (nonatomic, strong) NumberScrollView *sideNSV;

// Rotation based properties
@property (nonatomic) CGSize oldSize;

@end

@implementation PieceNumberView



#pragma mark - Instantiation

-(void)awakeFromNib {
    [super awakeFromNib];
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    return self;
}

-(void)layoutSubviews {
    if (!self.bottemNSV && !self.sideNSV) {
        [self setUp];
    }
    
    if (self.frame.size.width != self.oldSize.width ||
        self.frame.size.height != self.oldSize.height) {
        [self newFrameAdjustments];
    }
    self.oldSize = self.frame.size;
}

-(void)setUp {
    self.backgroundColor = nil;
    self.opaque = NO;
    
    // Make frame square
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.width);
    
    // Get maximum puzzle size based on device
    NSInteger maxPieceNumber;
    
    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"] ||
        [[UIDevice currentDevice].model isEqualToString:@"iPad Simulator"]) {
        maxPieceNumber = 10;
    } else {
        maxPieceNumber = 7;
    }
    
    self.bottemNSV = [[NumberScrollView alloc] initWithFrame:
                      CGRectMake(0,
                                 0,
                                 [self SQUARE_WIDTH] / 2,
                                 [self ARROW_HEIGHT])
                                               withMinNumber:2
                                               withMaxNumber:maxPieceNumber];
    self.bottemNSV.currentValue = 5;
    self.bottemNSV.delegate = self;
    [self addSubview:self.bottemNSV];
    
    self.sideNSV = [[NumberScrollView alloc] initWithFrame:
                    CGRectMake(0,
                               0,
                               [self ARROW_HEIGHT],
                               [self SQUARE_WIDTH] / 2)
                                             withMinNumber:2
                                             withMaxNumber:maxPieceNumber];
    self.sideNSV.currentValue = 5;
    self.sideNSV.delegate = self;
    [self addSubview:self.sideNSV];
    
    [self recenterNSVs];
}

-(void)recenterNSVs {
    self.bottemNSV.center = CGPointMake([self INDENT_LENGTH] * 2 + [self ARROW_HEIGHT] + [self SQUARE_WIDTH] / 2,
                                        [self INDENT_LENGTH] * 2 + [self SQUARE_WIDTH] + [self ARROW_HEIGHT] / 2);
    self.sideNSV.center = CGPointMake([self INDENT_LENGTH] + [self ARROW_HEIGHT] / 2,
                                      [self INDENT_LENGTH] + [self SQUARE_WIDTH] / 2);
}



#pragma mark - Setters and Getters

@synthesize selectedWidthNum = _selectedWidthNum;

-(NSUInteger)selectedWidthNum {
    return self.bottemNSV.currentValue;
}

-(void)setSelectedWidthNum:(NSUInteger)selectedWidthNum {
    self.bottemNSV.currentValue = selectedWidthNum;
}

@synthesize selectedHeightNum = _selectedHeightNum;

-(NSUInteger)selectedHeightNum {
    return self.sideNSV.currentValue;
}

-(void)setSelectedHeightNum:(NSUInteger)selectedHeightNum {
    self.sideNSV.currentValue = selectedHeightNum;
}



#pragma mark - Drawing

int CONER_RADIUS = 8;

-(int)SQUARE_WIDTH { return self.frame.size.width * 3 / 4; }
-(int)ARROW_HEIGHT { return self.frame.size.width * 1 / 8; }
-(int)INDENT_LENGTH { return (self.frame.size.width - [self SQUARE_WIDTH] - [self ARROW_HEIGHT]) / 3 ; }

- (void)drawRect:(CGRect)rect {
    
    // Draw the border and background of the view
    UIBezierPath *outline = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.frame.size.height / CONER_RADIUS];
    [outline addClip];
    [[UIColor colorWithRed:1 green:1 blue:1 alpha:.2] setFill];
    UIRectFill(self.bounds);

    // Draw each square cell
    for (NSUInteger widthIndex = 0; widthIndex < self.selectedWidthNum; widthIndex++) {
        for (NSUInteger heightIndex = 0; heightIndex < self.selectedHeightNum; heightIndex++) {
            UIBezierPath *squareCell = [UIBezierPath bezierPathWithRoundedRect:
                CGRectMake(self.frame.size.width - [self INDENT_LENGTH] - [self SQUARE_WIDTH] + widthIndex * [self SQUARE_WIDTH] / self.selectedWidthNum,
                           [self INDENT_LENGTH] + heightIndex * [self SQUARE_WIDTH] / self.selectedHeightNum,
                           [self SQUARE_WIDTH] / self.selectedWidthNum,
                           [self SQUARE_WIDTH] / self.selectedHeightNum)
                                                                 cornerRadius:[self SQUARE_WIDTH] / 3 / (self.selectedWidthNum + self.selectedHeightNum)];
            [[UIColor colorWithRed:1 green:1 blue:1 alpha:.8] setStroke];
            squareCell.lineWidth = 2;
            [squareCell stroke];
        }
    }
}

-(void)newFrameAdjustments {
    // Align each Number Scroll View
    [self recenterNSVs];
    
    // Allow square to be redrawn to correct size
    [self setNeedsDisplay];
}



#pragma mark - Actions

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self setNeedsDisplay];
}

@end
