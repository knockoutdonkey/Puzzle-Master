//
//  PUZButton.m
//  Puzzle Master
//
//  Created by Chris Lockwood on 11/17/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import "PUZButton.h"

@interface PUZButton()

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *fillColor;

@end

@implementation PUZButton



#pragma mark - Instantiation

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

-(void)setUp {
    self.fillColor = self.backgroundColor;
    
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}



#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    
    // Create outline path
    NSInteger smallestSideLength = (self.frame.size.width > self.frame.size.height) ? self.frame.size.height : self.frame.size.width;
    
    UIBezierPath *outline = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:smallestSideLength / 6];
    outline.lineWidth = 5;
    
    [outline addClip];
    
    [self.fillColor setFill];
    [outline fill];
    
    [[UIColor blackColor] setStroke];
    [outline stroke];
    
//    // Create Background Gradient Color
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = self.bounds;
//    gradient.colors = [NSArray arrayWithObjects:(id)[self.fillColor CGColor], (id)[self.fillColor CGColor], (id)[self.fillColor CGColor], (id)[[UIColor colorWithRed:.2 green:.2 blue:.2 alpha:1] CGColor], nil];
//    [self.layer insertSublayer:gradient atIndex:0];
//    gradient.startPoint = CGPointMake(1, 0);
//    gradient.endPoint = CGPointMake(0, 1);
//    
//    CAShapeLayer *mask = [CAShapeLayer layer];
//    mask.path = outline.CGPath;
//    
//    self.layer.mask = mask;
    
//    // Create outline
//    CAShapeLayer *outlineLayer = [CAShapeLayer layer];
//    outlineLayer.position = CGPointMake(-self.frame.origin.x, -self.frame.origin.y);
//    outlineLayer.lineWidth = 1;
//    outlineLayer.strokeColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor];
//    outlineLayer.fillColor = [[UIColor blackColor] CGColor];
//    outlineLayer.path = [outline CGPath];
//    
//    [self.layer insertSublayer:outlineLayer atIndex:[self.layer.sublayers count]];
    
    //Create Shadow
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 8;
    self.layer.shadowOffset = CGSizeMake(-5, 5);
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.5;
    
    self.layer.shadowPath = [outline CGPath];
}

@end
