//
//  SettingsButton.m
//  Puzzle Master
//
//  Created by Chris Lockwood on 11/7/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import "SettingsButton.h"

@implementation SettingsButton

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

-(void)setUp {
    self.titleLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:self.frame.size.height / 4];
    self.titleLabel.text = @"SETTINGS";
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *outline = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.frame.size.height / 6];
    outline.lineWidth = 5;
    
    [outline addClip];
    
    [[UIColor whiteColor] setFill];
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
