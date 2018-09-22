//
//  LocationPermissionViewController.m
//  Sunly
//
//  Created by Thomas Carayol on 21/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "LocationPermissionViewController.h"
#import "UIButton+Swag.h"
#import "UIColor+Additions.h"

#import <Lottie/Lottie.h>

@interface LocationPermissionViewController ()

@property (strong, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextStepButton;

@property (strong, nonatomic) LOTAnimationView * animationView;

@end

@implementation LocationPermissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self presenter] viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[self presenter] viewDidAppear];
}

- (IBAction)nextStepButtonAction:(id)sender {
    [[self presenter] nextButtonTapped];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - LocationPermissionPresenterToView

- (void)configureNextButton:(nonnull NSString *)title {
    [[self nextStepButton] nextStepWithTitle:title];
}

- (void)showLocationImageView:(nonnull UIImage *)image {
    [[self mainImageView] setImage:image];
}

- (void)showLocationMessage:(nonnull NSString *)message {
    [[self infoLabel] setText:message];
}

- (void)showWelcomeMessage:(nonnull NSString *)message {
    [[self welcomeLabel] setText:message];
}

- (void)configureBackgroundColor:(nonnull UIColor *)color {
    [[self view] setBackgroundColor:color];
}

- (void)showAlertWith:(NSString *)title and:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"LocationPermissionRestrictedOk", @"OnBoarding", @"") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showSettingsAlertWith:(NSString *)title and:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"LocationPermissionDeniedSettings", @"OnBoarding", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }];
    [alertController addAction:settingsAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)enableNextButton {
    [[self nextStepButton] setTitleColor:[[UIColor skyBlueColor] colorWithAlphaComponent:1.0] forState:UIControlStateNormal];
    [[self nextStepButton] setEnabled:YES];
}

- (void)disableNextButton {
    [[self nextStepButton] setTitleColor:[[UIColor skyBlueColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [[self nextStepButton] setEnabled:NO];
}

- (void)configureSearching {
    [UIView animateWithDuration:0.6 animations:^{
        [[self mainImageView] setAlpha:0.f];
        [[self infoLabel] setAlpha:0.f];
    } completion:^(BOOL finished) {
        if (finished) {
            [self showSearching];
        }
    }];
}

#pragma mark - Lottie animation

- (void)showSearching {
    if (!self.animationView) {
        self.animationView = [LOTAnimationView animationNamed:@"searching-animation"];
        [self.animationView setContentMode:UIViewContentModeScaleAspectFit];
        [self.animationView setLoopAnimation:YES];
        [self.animationView setAnimationSpeed:2.f];
        [self.animationView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.animationView play];
        [[self view] addSubview:self.animationView];
        [[[self.animationView centerXAnchor] constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
        [[[self.animationView centerYAnchor] constraintEqualToAnchor:self.view.centerYAnchor] setActive:YES];
        [[[self.animationView widthAnchor] constraintEqualToConstant:200.f] setActive:YES];
        [[[self.animationView heightAnchor] constraintEqualToConstant:200.f] setActive:YES];
    } else {
        [self.animationView play];
    }
}

@end
