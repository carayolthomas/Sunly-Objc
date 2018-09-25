//
//  DashboardRouter+Mock.m
//  SunlyTests
//
//  Created by Thomas Carayol on 25/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "DashboardRouter+Mock.h"
#import "DashboardInteractor+Mock.h"
#import "DashboardViewController+Mock.h"
#import "DashboardPresenter.h"

@implementation MockDashboardRouter

+ (UIViewController * _Nullable)createModule {
    
    MockDashboardViewController *view = [[MockDashboardViewController alloc] init];
    MockDashboardInteractor *interactor = [[MockDashboardInteractor alloc] init];
    MockDashboardRouter *router = [[MockDashboardRouter alloc] init];
    DashboardPresenter *presenter = [[DashboardPresenter alloc] initWithView:view interactor:interactor router:router];
    
    [view setPresenter:presenter];
    [interactor setPresenter:presenter];
    
    return view;
}

@end
