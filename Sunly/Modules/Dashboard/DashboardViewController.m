//
//  DashboardViewController.m
//  Sunly
//
//  Created by Thomas Carayol on 21/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "DashboardViewController.h"
#import "UIButton+Swag.h"

@interface DashboardViewController ()

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

@end
