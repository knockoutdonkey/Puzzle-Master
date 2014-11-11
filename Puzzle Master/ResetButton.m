//
//  ResetButton.m
//  Puzzle Master
//
//  Created by Chris Lockwood on 11/7/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import "ResetButton.h"

@implementation ResetButton



#pragma mark - Instantiation

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

-(void)setUp {
    self.titleLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:self.frame.size.height / 2];
    self.titleLabel.text = @"RESET";
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}



#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    UIBezierPath *outline = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.frame.size.height / 6];
    outline.lineWidth = 5;
    
    [outline addClip];
    
    [[UIColor redColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [outline stroke];
    
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 8; // if you like rounded corners
    self.layer.shadowOffset = CGSizeMake(-8, 8);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
    
    self.layer.shadowPath = [outline CGPath];
}

@end
