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

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet PieceNumberView *pieceNumberView;
@property (weak, nonatomic) IBOutlet ImageSelectionScrollView *imageScrollView;
@property (nonatomic) NSUInteger widthNum;
@property (nonatomic) NSUInteger heightNum;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundImage];
    
    [self.pieceNumberView setSelectedWidthNum:self.widthNum];
    [self.pieceNumberView setSelectedHeightNum:self.heightNum];
}


-(void)setBackgroundImage {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OakBackground"]];
    [imageView setFrame:self.view.frame];
    
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPushed:(id)sender {
    
    [self showPuzzleRestartWarning];

}

-(void)showPuzzleRestartWarning {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Apply New Settings?" message:@"Restart the puzzle in order to apply your new settings?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *restartAction = [UIAlertAction actionWithTitle:@"Apply" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self exitAndApplySettings];
    }];
    [alert addAction:restartAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Don't apply" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self exit];
    }];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

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
    self.widthNum = widthNum;
    self.heightNum = heightNum;
}

@end
