//
//  SettingsViewController.m
//  Puzzle Master
//
//  Created by Chris Lockwood on 11/8/14.
//  Copyright (c) 2014 Chris Lockwood. All rights reserved.
//

#import "SettingsViewController.h"
#import "ViewController.h"
#import "ImageSelectionScrollView.h"
#import "PieceNumberView.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet PieceNumberView *pieceNumberView;
@property (weak, nonatomic) IBOutlet ImageSelectionScrollView *imageScrollView;
@property (nonatomic) NSUInteger widthNum;
@property (nonatomic) NSUInteger heightNum;

@end

@implementation SettingsViewController



#pragma mark - Instantiation

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.pieceNumberView setSelectedWidthNum:self.widthNum];
    [self.pieceNumberView setSelectedHeightNum:self.heightNum];
}

#pragma mark - Actions

- (IBAction)confirmButtonPushed:(id)sender {
    
    [self exitAndApplySettings];

}

- (IBAction)cancelButtonPushed:(id)sender {
    
    [self exit];
    
}



#pragma mark - Navigation

-(void)exitAndApplySettings{
    NSUInteger controllerIndex = self.navigationController.viewControllers.count - 2;
    
    if ([[self.navigationController.viewControllers objectAtIndex:controllerIndex] isKindOfClass:[ViewController class]]) {
        ViewController *vc = (ViewController *) [self.navigationController.viewControllers objectAtIndex:controllerIndex];
        [vc createNewPuzzleWithWidthNum:self.pieceNumberView.selectedWidthNum
                          withHeightNum:self.pieceNumberView.selectedHeightNum
                              withImage:self.imageScrollView.selectedImage];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)exit{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)useOldWidthNum:(NSUInteger)widthNum heightNum:(NSUInteger)heightNum image:(UIImage *)image {
    self.pieceNumberView.selectedWidthNum = 7;
    self.pieceNumberView.selectedHeightNum = 7;
}



#pragma mark - Preferances

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}



//#pragma mark - Rotation
//
//-(void)setConstraintsForPortrait {
//    
//}
//
//-(void)setConstraintsForLandscape {
//    
//}
//
//-(BOOL)shouldAutorotate {
//    return YES;
//}
//
//-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    
//    // If in landscape mode
//    if (size.width > size.height) {
//        [self setFramesForLandscape];
//    } else {
//        [self setFramesForPortrait];
//    }
//    
//}

@end
