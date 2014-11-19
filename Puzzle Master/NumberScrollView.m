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

@property (nonatomic, strong) UILabel *rightDownIndicatorArrow;
@property (nonatomic, strong) UILabel *leftUpIndicatorArrow;

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
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    
    for (NSInteger index = 0; index <= self.maxNumber - self.minNumber; index++) {
        UILabel *numberLabel;
        if (self.isVertical) {
            numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                    self.frame.size.height * index,
                                                                    self.frame.size.width,
                                                                    self.frame.size.height)];
            numberLabel.text = [NSString stringWithFormat:@"%ld", (long)(self.maxNumber - index)];
        } else {
            numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width * index,
                                                                     0,
                                                                     self.frame.size.width,
                                                                     self.frame.size.height)];
            numberLabel.text = [NSString stringWithFormat:@"%ld", (long)(self.minNumber + index)];
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
    
    [self createIndicatorArrows];
}

-(void)createIndicatorArrows {
    self.rightDownIndicatorArrow = [[UILabel alloc] init];
    self.rightDownIndicatorArrow.text = @"→";
    self.rightDownIndicatorArrow.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.5];
    self.rightDownIndicatorArrow.font = [UIFont fontWithName:nil size:30];
    [self.rightDownIndicatorArrow sizeToFit];
    [self.rightDownIndicatorArrow addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrowScroll:)]];
    self.rightDownIndicatorArrow.userInteractionEnabled = YES;
    
    self.leftUpIndicatorArrow = [[UILabel alloc] init];
    self.leftUpIndicatorArrow.text = @"←";
    self.leftUpIndicatorArrow.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.5];
    self.leftUpIndicatorArrow.font = [UIFont fontWithName:nil size:30];
    [self.leftUpIndicatorArrow sizeToFit];
    [self.leftUpIndicatorArrow addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrowScroll:)]];
    self.leftUpIndicatorArrow.userInteractionEnabled = YES;
    
    if (self.isVertical) {
        self.rightDownIndicatorArrow.text = @"↓";
        self.leftUpIndicatorArrow.text = @"↑";
    }
    
    [self addSubview:self.rightDownIndicatorArrow];
    [self addSubview:self.leftUpIndicatorArrow];
}



#pragma mark - Setters and Getters

// The direction that the ScrollView scrolls is determined by which dimension of the ScrollView is longer

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
    // Only allow value to change for valid values
    if (currentValue < self.minNumber || currentValue > self.maxNumber) {
        return;
    }
    
    if (!self.isVertical) {
        self.contentOffset = CGPointMake((currentValue - self.minNumber) * self.frame.size.width, self.contentOffset.y);
    } else {
        self.contentOffset = CGPointMake(self.contentOffset.x, self.frame.size.height * (self.maxNumber - currentValue));
    }
    _currentValue = currentValue;
}



#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    UIBezierPath *outline = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:(self.frame.size.height + self.frame.size.width) / 16];
    
    [outline addClip];
    
    [[UIColor colorWithRed:1 green:1 blue:1 alpha:.2] setFill];
    UIRectFill(self.bounds);
    
    // Move arrows witht he scroll view
    if (!self.isVertical) {
        self.rightDownIndicatorArrow.center = CGPointMake(self.contentOffset.x + (1 - .2) * self.frame.size.width, self.frame.size.height / 2);
        
        self.leftUpIndicatorArrow.center = CGPointMake(self.contentOffset.x + .2 * self.frame.size.width, self.frame.size.height / 2);
    } else {
        self.leftUpIndicatorArrow.center = CGPointMake(self.frame.size.width / 2, self.contentOffset.y + .2 * self.frame.size.height);
        
        self.rightDownIndicatorArrow.center = CGPointMake(self.frame.size.width / 2, self.contentOffset.y + .8 * self.frame.size.height);
    }
    
    // Hides right arrow if the ScrollView is all the way to the right
    if (self.contentOffset.x < self.contentSize.width - self.frame.size.width ||
        self.contentOffset.y < self.contentSize.height - self.frame.size.height) {
        if (self.rightDownIndicatorArrow.textColor == [UIColor clearColor]) {
            
            [self.rightDownIndicatorArrow.layer addAnimation:[self getAnimation] forKey:@"changeTextTransition"];
            
            self.rightDownIndicatorArrow.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        }
    } else {
        if (self.rightDownIndicatorArrow.textColor != [UIColor clearColor]) {
            
            
            [self.rightDownIndicatorArrow.layer addAnimation:[self getAnimation] forKey:@"changeTextTransition"];
            
            self.rightDownIndicatorArrow.textColor = [UIColor clearColor];
        }
    }
    
    // Hides left arrow if the ScrollView is all the way to the left
    if (self.contentOffset.x > 0 ||
        self.contentOffset.y > 0) {
        if (self.leftUpIndicatorArrow.textColor == [UIColor clearColor]) {
            
            [self.leftUpIndicatorArrow.layer addAnimation:[self getAnimation] forKey:@"changeTextTransition"];
            
            self.leftUpIndicatorArrow.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        }
    } else {
        if (self.leftUpIndicatorArrow.textColor != [UIColor clearColor]) {
            
            [self.leftUpIndicatorArrow.layer addAnimation:[self getAnimation] forKey:@"changeTextTransition"];
            
            self.leftUpIndicatorArrow.textColor = [UIColor clearColor];
        }
    }
}

-(CATransition *)getAnimation {
    CATransition *animation = [CATransition animation];
    animation.duration = .2;
    animation.type = kCATransitionFade;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return animation;
}



#pragma mark - Action

-(void)arrowScroll:(UITapGestureRecognizer *)arrow {
    UILabel *arrowLabel = (UILabel *)arrow.view;
    
    if ([arrowLabel.text isEqualToString:@"→"]) {
        self.currentValue++;
    } else if ([arrowLabel.text isEqualToString:@"←"]) {
        self.currentValue--;
    } else if ([arrowLabel.text isEqualToString:@"↓"]) {
        self.currentValue--;
    } else {
        self.currentValue++;
    }
}
@end
