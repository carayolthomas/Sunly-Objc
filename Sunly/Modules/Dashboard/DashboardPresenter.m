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
    [[self view] showComputing];
    [[self interactor] fetchContactsAndForecastData];
}

#pragma mark - DashboardInteractorToPresenter

- (void)currentWeather:(Weather * _Nullable)currentWeather bestCurrent:(Weather * _Nullable)bestCurrent worstCurrent:(Weather * _Nullable)worstCurrent bestNext:(Weather * _Nullable)bestNext worstNext:(Weather * _Nullable)worstNext {
    [[self view] hideComputing];
    NSLog(@"currentWeather : %@", currentWeather);
    NSLog(@"bestCurrent : %@", bestCurrent);
    NSLog(@"worstCurrent : %@", worstCurrent);
    NSLog(@"bestNext : %@", bestNext);
    NSLog(@"worstNext : %@", worstNext);
    // TODO:
}

- (void)fetchContactsAndForecastDataFinished {
    [[self interactor] getDashboardData];
}

- (void)getForecastError:(nonnull NSString *)city country:(nonnull NSString *)country {
    // TODO:
    NSLog(@"Couldn't get forecast for %@, %@", city, country);
}

- (void)commonStorageError {
    // TODO:
    NSLog(@"Storage error...");
}

@end
