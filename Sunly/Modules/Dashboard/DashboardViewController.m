//
//  DashboardViewController.m
//  Sunly
//
//  Created by Thomas Carayol on 21/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "DashboardViewController.h"
#import "UIButton+Swag.h"

#import <Lottie/Lottie.h>

@interface DashboardViewController ()

@property (strong, nonatomic) LOTAnimationView *animationView;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self presenter] viewDidLoad];
}

#pragma mark - DashboardPresenterToView

- (void)showWelcomeMessage:(NSString *)message {
    [self setTitle:message];
}

- (void)showComputing {
    [self showMainAnimation];
}

- (void)hideComputing {
    [self hideMainAnimation];
}

#pragma mark - Lottie animation

- (void)showMainAnimation {
    if (!self.animationView) {
        self.animationView = [LOTAnimationView animationNamed:@"compute-data-animation"];
        [self.animationView setContentMode:UIViewContentModeScaleAspectFit];
        [self.animationView setLoopAnimation:YES];
        [self.animationView setAnimationSpeed:1.f];
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

- (void)hideMainAnimation {
    if (self.animationView) {
        [self.animationView stop];
    }
}

@end
