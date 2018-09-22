//
//  OnBoardingNavigationController.m
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "OnBoardingNavigationController.h"
#import "UIColor+Additions.h"

@interface OnBoardingNavigationController () <UINavigationControllerDelegate>

@end

@implementation OnBoardingNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarHidden:YES];
    [self setDelegate:self];
    [[self navigationBar] setBarTintColor:[UIColor skyBlueColor]];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // TODO:
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
