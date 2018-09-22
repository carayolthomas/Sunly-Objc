//
//  ContactPermissionRouter.m
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "ContactPermissionRouter.h"
#import "ContactPermissionViewController.h"
#import "ContactPermissionPresenter.h"
#import "ContactPermissionInteractor.h"
#import "Constants.h"


@implementation ContactPermissionRouter

+ (UIViewController * _Nullable)createModule {
    ContactPermissionViewController *view = [[UIStoryboard storyboardWithName:OnBoardingStoryboardName bundle:nil] instantiateViewControllerWithIdentifier:ContactPermissionViewControllerIdentifier];
    ContactPermissionInteractor *interactor = [ContactPermissionInteractor new];
    ContactPermissionRouter *router = [ContactPermissionRouter new];
    ContactPermissionPresenter *presenter = [[ContactPermissionPresenter alloc] initWithView:view interactor:interactor router:router];
    view.presenter = presenter;
    interactor.presenter = presenter;
    return view;
}

- (void)showNextStepFrom:(nonnull id<ContactPermissionPresenterToView>)view {
    // TODO:
}

@end
