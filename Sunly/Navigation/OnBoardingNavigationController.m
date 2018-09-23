//
//  OnBoardingNavigationController.m
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "OnBoardingNavigationController.h"
#import "UIColor+Additions.h"
#import "DashboardViewController.h"

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

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[DashboardViewController class]]) {
        [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

@end
