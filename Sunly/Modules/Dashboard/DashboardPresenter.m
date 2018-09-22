//
//  DashboardPresenter.m
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "DashboardPresenter.h"
#import "UIColor+Additions.h"

@implementation DashboardPresenter

@synthesize interactor;
@synthesize router;
@synthesize view;

- (instancetype)initWithView:(id<DashboardPresenterToView> __nullable)view
                  interactor:(id<DashboardPresenterToInteractor> __nullable)interactor
                      router:(id<DashboardPresenterToRouter> __nullable)router {
    
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        self.router = router;
    }
    return self;
}

#pragma mark - DashboardViewToPresenter

- (void)viewDidLoad {
    [[self view] showWelcomeMessage:NSLocalizedStringFromTable(@"DashboardWelcome", @"OnBoarding", @"")];
}

@end
