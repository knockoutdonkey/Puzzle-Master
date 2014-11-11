//
//  NumberScrollView.h
//  Puzzle Master
//
//  Created by Chris Lockwood on 11/10/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberScrollView : UIScrollView

@property (nonatomic) NSInteger currentValue;
@property (nonatomic) BOOL isVertical;

-(instancetype)initWithFrame:(CGRect)frame
               withMinNumber:(NSInteger)minNumber
               withMaxNumber:(NSInteger)maxNumber;

@end
