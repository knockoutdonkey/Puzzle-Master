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

@property (nonatomic, strong) NSMutableArray *puzzleImageViews;

@end

@implementation ImageSelectionScrollView



#pragma mark - Instantitation

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    [self setUp];
    return self;
}

-(void)setUp {
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    
    self.pagingEnabled = YES;
    self.bounces = YES;
    self.showsHorizontalScrollIndicator = YES;
    
    NSInteger rowsPerPage = 2;
    NSInteger columnsPerPage = 2;
    NSInteger indentSize = self.frame.size.height / rowsPerPage / 6;
    for (int i = 0; i < [[ImageSelectionScrollView imageFileNames] count] / columnsPerPage + .99; i++) {
        for (int j = 0; j < rowsPerPage; j++) {
            if (i * rowsPerPage + j < [[ImageSelectionScrollView imageFileNames] count]) {
                UIImageView *puzzleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(NSString *)[ImageSelectionScrollView imageFileNames][i * rowsPerPage + j]]];
                puzzleImageView.center = CGPointMake((i + .5) * self.frame.size.width / columnsPerPage, (j + .5) * self.frame.size.height / rowsPerPage);
                [puzzleImageView setBounds:CGRectMake(puzzleImageView.frame.origin.x, puzzleImageView.frame.origin.y, self.frame.size.width / columnsPerPage - 2 * indentSize, self.frame.size.height / rowsPerPage - 2 * indentSize)];
                
                UITapGestureRecognizer *tapRecognzier = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detectTap:)];
                puzzleImageView.userInteractionEnabled = YES;
                [puzzleImageView addGestureRecognizer:tapRecognzier];
                
                [self addSubview:puzzleImageView];
                [self.puzzleImageViews addObject:puzzleImageView];
            }
        }
    }
    
    self.contentSize = CGSizeMake(self.frame.size.width * [[ImageSelectionScrollView imageFileNames] count] / rowsPerPage, self.frame.size.height);
    
    [self selectImageInView:(UIImageView *)self.puzzleImageViews[0]];
}

-(NSArray *)puzzleImageViews {
    if (!_puzzleImageViews) {
        _puzzleImageViews = [NSMutableArray array];
    }
    
    return _puzzleImageViews;
}




+(NSArray *)imageFileNames {
    return @[@"TheWitnessBlossoms",
             @"TheWitnessWindmill",
             @"TheWitnessPath",
             @"TheWitnessAutumn",
             @"TheWitnessDesert"];
}



#pragma mark - Actions

-(void)detectTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    UIImageView *selectedImageView = (UIImageView *)tapGestureRecognizer.view;
    
    [self selectImageInView:selectedImageView];
    
    self.selectedImage = selectedImageView.image;
}



#pragma mark - Drawing

int CORNER_RADIUS = 8;

- (void)drawRect:(CGRect)rect {
    UIBezierPath *outline = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.frame.size.height / CORNER_RADIUS];
    
    [outline addClip];
    
    [[UIColor colorWithRed:1 green:1 blue:1 alpha:.2] setFill];
    UIRectFill(self.bounds);

    
    if (self.contentOffset.x > 0) {
//        UIImage *arrowImage = [UIImage imageNamed:@"Arrow"];
//        arrowImage = [UIImage imageWithCGImage:arrowImage.CGImage scale:2.0 orientation:UIImageOrientationDown];
//        UIImageView *arrow = [[UIImageView alloc] initWithImage:arrowImage];
//        
//        arrow.center = CGPointMake(self.frame.size.width * 9 / 10, self.frame.size.height / 2);
//        [self addSubview:arrow];
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


@end