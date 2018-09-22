//
//  LocationPermissionProtocols.h
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - LocationPermissionInteractorToPresenter

/// Delegates from the interactor (api/storage) to the presenter (business rules)
@protocol LocationPermissionInteractorToPresenter <NSObject>
@end

#pragma mark - LocationPermissionPresenterToView

/// Delegates from the presenter (business rules) to the view (ui)
@protocol LocationPermissionPresenterToView <NSObject>

@required

/// Shows a welcome message at the top of the view
/// - parameter: message The message
- (void)showWelcomeMessage:(NSString *)message;

/// Shows a contextualized image view
/// - parameter: image The image to render
- (void)showLocationImageView:(UIImage *)image;

/// Shows a message at the bottom of the image view
/// - parameter: message The message
- (void)showLocationMessage:(NSString *)message;

/// Configure the action button
/// - parameter: title The button title
- (void)configureNextButton:(NSString *)title;

/// Configure the view background color
/// - parameter: color The background color
- (void)configureBackgroundColor:(UIColor *)color;

/// Shows a basic alert with cancel button
/// - parameter: title The title
/// - parameter: message The message
- (void)showAlertWith:(NSString *)title and:(NSString *)message;

/// Shows an alert with a cancel button and an app settings button
/// - parameter: title The title
/// - parameter: message The message
- (void)showSettingsAlertWith:(NSString *)title and:(NSString *)message;

/// Enable the main button
- (void)enableNextButton;

/// Disable the main button
- (void)disableNextButton;

/// Configure the view while getting user location
- (void)configureSearching;

@end

#pragma mark - LocationPermissionPresenterToInteractor

/// Delegates from the presenter (business rules) to the interactor (api/storage)
@protocol LocationPermissionPresenterToInteractor <NSObject>

@required
@property (nonatomic, weak, nullable) id<LocationPermissionInteractorToPresenter> presenter;

/// Store the user coordinate
- (void)storeUserCoordinate:(NSString *)coordinate;

@end

#pragma mark - LocationPermissionPresenterToRouter

/// Delegates from the presenter (business rules) to the router (navigation)
@protocol LocationPermissionPresenterToRouter <NSObject>

@required

/// Initialize and create a module
+ (UIViewController* _Nullable)createModule;

/// Show the next module
- (void)showNextStepFrom:(id<LocationPermissionPresenterToView>)view;

@end

/// Delegates from the view (ui) to the presenter (business rules)
@protocol LocationPermissionViewToPresenter <NSObject>

@required

@property (nonatomic, weak, nullable) id<LocationPermissionPresenterToView> view;
@property (nonatomic, nullable) id<LocationPermissionPresenterToInteractor> interactor;
@property (nonatomic, nullable) id<LocationPermissionPresenterToRouter> router;

/// Callback when view is loaded
- (void)viewDidLoad;

/// Callback when view has appeared
- (void)viewDidAppear;

/// Callback when next button is tapped
- (void)nextButtonTapped;

@end

NS_ASSUME_NONNULL_END
