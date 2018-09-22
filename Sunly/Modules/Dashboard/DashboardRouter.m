//
//  DashboardRouter.m
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "DashboardRouter.h"
#import "DashboardViewController.h"
#import "DashboardPresenter.h"
#import "DashboardInteractor.h"
#import "Constants.h"

@implementation DashboardRouter

+ (UIViewController * _Nullable)createModule {
    DashboardViewController *view = [[UIStoryboard storyboardWithName:DashboardStoryboardName bundle:nil] instantiateViewControllerWithIdentifier:DashboardViewControllerIdentifier];
    DashboardInteractor *interactor = [DashboardInteractor new];
    DashboardRouter *router = [DashboardRouter new];
    DashboardPresenter *presenter = [[DashboardPresenter alloc] initWithView:view interactor:interactor router:router];
    view.presenter = presenter;
    interactor.presenter = presenter;
    return view;
}

@end
