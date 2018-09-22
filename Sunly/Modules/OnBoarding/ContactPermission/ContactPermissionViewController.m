//
//  ContactPermissionViewController.m
//  Sunly
//
//  Created by Thomas Carayol on 21/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "ContactPermissionViewController.h"
#import "UIButton+Swag.h"

@interface ContactPermissionViewController ()

@property (strong, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextStepButton;

@end

@implementation ContactPermissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self presenter] viewDidLoad];
}

- (IBAction)nextStepButtonAction:(id)sender {
    [[self presenter] nextButtonTapped];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - ContactPermissionPresenterToView

- (void)configureNextButton:(nonnull NSString *)title {
    [[self nextStepButton] nextStepWithTitle:title];
}

- (void)showContactImageView:(nonnull UIImage *)image {
    [[self mainImageView] setImage:image];
}

- (void)showContactMessage:(nonnull NSString *)message {
    [[self infoLabel] setText:message];
}

- (void)showWelcomeMessage:(nonnull NSString *)message {
    [[self welcomeLabel] setText:message];
}

- (void)configureBackgroundColor:(nonnull UIColor *)color {
    [[self view] setBackgroundColor:color];
}

@end
