//
//  ImageSelectionScrollView.m
//  Puzzle Master
//
//  Created by Chris Lockwood on 11/9/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import "ImageSelectionScrollView.h"
#import <QuartzCore/QuartzCore.h>

@interface ImageSelectionScrollView()

// Subviews
@property (nonatomic, strong) NSMutableArray *puzzleImageViews;
@property (nonatomic, strong) UILabel *leftIndicatorArrow;
@property (nonatomic, strong) UILabel *rightIndicatorArrow;

// Rotation based properties
@property (nonatomic) CGSize oldSize;

@end

@implementation ImageSelectionScrollView



#pragma mark - Instantitation

-(void)awakeFromNib {
    [super awakeFromNib];
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    return self;
}

-(void)layoutSubviews {
    if (!self.leftIndicatorArrow || !self.rightIndicatorArrow) {
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
    self.contentMode = UIViewContentModeRedraw;
    
    self.pagingEnabled = YES;
    self.bounces = NO;
    self.showsHorizontalScrollIndicator = YES;
    
    [self createImageViews];
    [self createIndicatorArrows];
}

NSInteger ROWS_PER_PAGE = 2;
NSInteger COLUMNS_PER_PAGE = 2;
-(NSInteger)indentSize { return self.frame.size.height / ROWS_PER_PAGE / 6; };

-(void)createImageViews {
    
    for (int i = 0; i < [[ImageSelectionScrollView imageFileNames] count] / COLUMNS_PER_PAGE + .99; i++) {
        for (int j = 0; j < ROWS_PER_PAGE; j++) {
            if (i * ROWS_PER_PAGE + j < [[ImageSelectionScrollView imageFileNames] count]) {
                UIImageView *puzzleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(NSString *)[ImageSelectionScrollView imageFileNames][i * ROWS_PER_PAGE + j]]];
                puzzleImageView.center = CGPointMake((i + .5) * self.frame.size.width / COLUMNS_PER_PAGE, (j + .5) * self.frame.size.height / ROWS_PER_PAGE);
                [puzzleImageView setBounds:CGRectMake(puzzleImageView.frame.origin.x, puzzleImageView.frame.origin.y, self.frame.size.width / COLUMNS_PER_PAGE - 2 * [self indentSize], self.frame.size.height / ROWS_PER_PAGE - 2 * [self indentSize])];
                
                UITapGestureRecognizer *tapRecognzier = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detectTap:)];
                puzzleImageView.userInteractionEnabled = YES;
                [puzzleImageView addGestureRecognizer:tapRecognzier];
                
                [self addSubview:puzzleImageView];
                [self.puzzleImageViews addObject:puzzleImageView];
            }
        }
    }

    self.contentSize = CGSizeMake(self.frame.size.width * (([[ImageSelectionScrollView imageFileNames] count] + (COLUMNS_PER_PAGE * ROWS_PER_PAGE) - 1) / (COLUMNS_PER_PAGE * ROWS_PER_PAGE)), self.frame.size.height);
    
    [self selectImageInView:(UIImageView *)self.puzzleImageViews[0]];
}

-(void)createIndicatorArrows {
    self.rightIndicatorArrow = [[UILabel alloc] init];
    self.rightIndicatorArrow.text = @"→";
    self.rightIndicatorArrow.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.5];
    self.rightIndicatorArrow.font = [UIFont fontWithName:nil size:self.frame.size.width / 8];
    [self.rightIndicatorArrow sizeToFit];
    [self.rightIndicatorArrow addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrowScroll:)]];
    self.rightIndicatorArrow.userInteractionEnabled = YES;
    
    [self addSubview:self.rightIndicatorArrow];
    
    self.leftIndicatorArrow = [[UILabel alloc] init];
    self.leftIndicatorArrow.text = @"←";
    self.leftIndicatorArrow.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.5];
    self.leftIndicatorArrow.font = [UIFont fontWithName:nil size:self.frame.size.width / 8];
    [self.leftIndicatorArrow sizeToFit];
    [self.leftIndicatorArrow addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrowScroll:)]];
    self.leftIndicatorArrow.userInteractionEnabled = YES;

    [self addSubview:self.leftIndicatorArrow];
}

+(NSArray *)imageFileNames {
    return @[@"TheWitnessBlossoms",
             @"TheWitnessWindmill",
             @"TheWitnessPath",
             @"TheWitnessAutumn",
             @"TheWitnessDesert"];
}



#pragma mark - Getters and Setters

-(NSArray *)puzzleImageViews {
    if (!_puzzleImageViews) {
        _puzzleImageViews = [NSMutableArray array];
    }
    
    return _puzzleImageViews;
}



#pragma mark - Actions

-(void)detectTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    UIImageView *selectedImageView = (UIImageView *)tapGestureRecognizer.view;
    
    [self selectImageInView:selectedImageView];
}

-(void)arrowScroll:(UITapGestureRecognizer *)arrow {
    UILabel *arrowLabel = (UILabel *)arrow.view;
    
    if ([arrowLabel.text isEqualToString:@"→"]) {
        if (self.contentOffset.x < self.contentSize.width - self.frame.size.width) {
            self.contentOffset = CGPointMake(self.contentOffset.x + self.frame.size.width, self.contentOffset.y);
        }
    } else {
        if (self.contentOffset.x > 0) {
            self.contentOffset = CGPointMake(self.contentOffset.x - self.frame.size.width, self.contentOffset.y);
        }
    }
}

-(void)selectImageInView:(UIImageView *)selectingImageView {
    for (UIImageView *imageView in self.puzzleImageViews) {
        [imageView.layer setBorderColor: [[UIColor clearColor] CGColor]];
    }
    
    [selectingImageView.layer setBorderColor: [[UIColor yellowColor] CGColor]];
    [selectingImageView.layer setBorderWidth: 2.0];
    
    self.selectedImage = selectingImageView.image;
}



#pragma mark - Drawing

int CORNER_RADIUS = 8;

- (void)drawRect:(CGRect)rect {
    UIBezierPath *outline = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.frame.size.height / CORNER_RADIUS];
    
    [outline addClip];
    
    [[UIColor colorWithRed:1 green:1 blue:1 alpha:.2] setFill];
    UIRectFill(self.bounds);
    
    [self recenterIndicatorArrows];
    
    // Hides right arrow if the ScrollView is all the way to the right
    if (self.contentOffset.x < self.contentSize.width - self.frame.size.width) {
        if (self.rightIndicatorArrow.textColor == [UIColor clearColor]) {
            
            [self.rightIndicatorArrow.layer addAnimation:[self getAnimation] forKey:@"changeTextTransition"];
            self.rightIndicatorArrow.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        }
    } else {
        if (self.rightIndicatorArrow.textColor != [UIColor clearColor]) {
            
            [self.rightIndicatorArrow.layer addAnimation:[self getAnimation] forKey:@"changeTextTransition"];
            self.rightIndicatorArrow.textColor = [UIColor clearColor];
        }
    }
    
    // Hides left arrow if the ScrollView is all the way to the left
    if (self.contentOffset.x > 0) {
        if (self.leftIndicatorArrow.textColor == [UIColor clearColor]) {
            
            [self.leftIndicatorArrow.layer addAnimation:[self getAnimation] forKey:@"changeTextTransition"];
            self.leftIndicatorArrow.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        }
    } else {
        if (self.leftIndicatorArrow.textColor != [UIColor clearColor]) {
            
            [self.leftIndicatorArrow.layer addAnimation:[self getAnimation] forKey:@"changeTextTransition"];
            self.leftIndicatorArrow.textColor = [UIColor clearColor];
        }
    }
}

-(void)recenterIndicatorArrows {
    self.rightIndicatorArrow.center = CGPointMake(self.contentOffset.x + 9 * self.frame.size.width / 10, self.frame.size.height / 2);
    
    self.leftIndicatorArrow.center = CGPointMake(self.contentOffset.x + 1 * self.frame.size.width / 10, self.frame.size.height / 2);
}

-(CATransition *)getAnimation {
    CATransition *animation = [CATransition animation];
    animation.duration = .3;
    animation.type = kCATransitionFade;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return animation;
}

-(void)newFrameAdjustments {
    [self setNeedsDisplay];
    
    for (int i = 0; i < [self.puzzleImageViews count] / COLUMNS_PER_PAGE + .99; i++) {
        for (int j = 0; j < ROWS_PER_PAGE; j++) {
            if (i * ROWS_PER_PAGE + j < [self.puzzleImageViews count]) {
                
                UIImageView *puzzleImageView = self.puzzleImageViews[i * COLUMNS_PER_PAGE + j];
                puzzleImageView.center = CGPointMake((i + .5) * self.frame.size.width / COLUMNS_PER_PAGE, (j + .5) * self.frame.size.height / ROWS_PER_PAGE);
                puzzleImageView.bounds = CGRectMake(puzzleImageView.frame.origin.x, puzzleImageView.frame.origin.y, self.frame.size.width / COLUMNS_PER_PAGE - 2 * [self indentSize], self.frame.size.height / ROWS_PER_PAGE - 2 * [self indentSize]);
            }
        }
    }
}

@end
