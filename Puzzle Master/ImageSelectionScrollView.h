//
//  ImageSelectionScrollView.h
//  Puzzle Master
//
//  Created by Chris Lockwood on 11/9/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageSelectionScrollView : UIScrollView

@property (nonatomic, strong) UIImage *selectedImage;

+(NSArray *)imageFileNames;

@end
