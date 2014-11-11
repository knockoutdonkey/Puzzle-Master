//
//  NumberScrollView.m
//  Puzzle Master
//
//  Created by Chris Lockwood on 11/10/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import "NumberScrollView.h"

@interface NumberScrollView()

@property (nonatomic) NSInteger maxNumber;
@property (nonatomic) NSInteger minNumber;


@end

@implementation NumberScrollView



#pragma mark - Instantiation

-(instancetype)initWithFrame:(CGRect)frame
               withMinNumber:(NSInteger)minNumber
               withMaxNumber:(NSInteger)maxNumber {
    self = [super initWithFrame:frame];
    
    self.maxNumber = maxNumber;
    self.minNumber = minNumber;
    
    [self setUp];
    return self;
}

-(void)setUp {
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    
    self.pagingEnabled = YES;
    self.bounces = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    for (NSInteger index = 0; index <= self.maxNumber - self.minNumber; index++) {
        UILabel *numberLabel;
        if (self.isVertical) {
            numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                    self.frame.size.height * index,
                                                                    self.frame.size.width,
                                                                    self.frame.size.height)];
            numberLabel.text = [NSString stringWithFormat:@"%d", self.maxNumber - index];
        } else {
            numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width * index,
                                                                     0,
                                                                     self.frame.size.width,
                                                                     self.frame.size.height)];
            numberLabel.text = [NSString stringWithFormat:@"%d", self.minNumber + index];
        }
        
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.font = [UIFont fontWithName:nil size:25];
        [self addSubview:numberLabel];
    }

    if (self.isVertical) {
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height * (self.maxNumber - self.minNumber + 1));
    } else {
        self.contentSize = CGSizeMake(self.frame.size.width * (self.maxNumber - self.minNumber + 1), self.frame.size.height);
    }
}



#pragma mark - Setters and Getters

-(BOOL)isVertical {
    if (self.frame.size.height > self.frame.size.width) {
        return YES;
    }
    return NO;
}

@synthesize currentValue = _currentValue;

-(NSInteger)currentValue {
    NSInteger value = (self.contentOffset.x + self.frame.size.width / 2) / self.frame.size.width + self.minNumber;
    if (self.isVertical) {
        value = self.maxNumber - (self.contentOffset.y + self.frame.size.height / 2) / self.frame.size.height + 1;
    }
    _currentValue = value;
    return _currentValue;
}

-(void)setCurrentValue:(NSInteger)currentValue {
    if (!self.isVertical) {
        self.contentOffset = CGPointMake((currentValue - self.minNumber) * self.frame.size.width, self.contentOffset.y);
    } else {
        self.contentOffset = CGPointMake(self.contentOffset.x, self.frame.size.height * (self.maxNumber - currentValue));
    }
    _currentValue = currentValue;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *outline = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:(self.frame.size.height + self.frame.size.width) / 16];
    
    [outline addClip];
    
    [[UIColor colorWithRed:1 green:1 blue:1 alpha:.2] setFill];
    UIRectFill(self.bounds);
}

@end
