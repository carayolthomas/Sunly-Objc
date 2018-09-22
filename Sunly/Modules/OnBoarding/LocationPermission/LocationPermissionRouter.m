//
//  LocationPermissionRouter.m
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "LocationPermissionRouter.h"
#import "LocationPermissionViewController.h"
#import "LocationPermissionPresenter.h"
#import "LocationPermissionInteractor.h"
#import "Constants.h"
#import "DashboardRouter.h"


@implementation LocationPermissionRouter

+ (UIViewController * _Nullable)createModule {
    LocationPermissionViewController *view = [[UIStoryboard storyboardWithName:OnBoardingStoryboardName bundle:nil] instantiateViewControllerWithIdentifier:LocationPermissionViewControllerIdentifier];
    LocationPermissionInteractor *interactor = [LocationPermissionInteractor new];
    LocationPermissionRouter *router = [LocationPermissionRouter new];
    LocationPermissionPresenter *presenter = [[LocationPermissionPresenter alloc] initWithView:view interactor:interactor router:router];
    view.presenter = presenter;
    interactor.presenter = presenter;
    return view;
}

- (void)showNextStepFrom:(nonnull id<LocationPermissionPresenterToView>)view {
    UIViewController *nextStep = [DashboardRouter createModule];
    [[(UIViewController *)view navigationController] setViewControllers:@[nextStep] animated:YES];
}

@end
