//
//  ContactPermissionProtocols.h
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@import Contacts;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ContactPermissionInteractorToPresenter

/// Delegates from the interactor (api/storage) to the presenter (business rules)
@protocol ContactPermissionInteractorToPresenter <NSObject>
@end

#pragma mark - ContactPermissionPresenterToView

/// Delegates from the presenter (business rules) to the view (ui)
@protocol ContactPermissionPresenterToView <NSObject>

@required

/// Shows a welcome message at the top of the view
/// - parameter: message The message
- (void)showWelcomeMessage:(NSString *)message;

/// Shows a contextualized image view
/// - parameter: image The image to render
- (void)showContactImageView:(UIImage *)image;

/// Shows a message at the bottom of the image view
/// - parameter: message The message
- (void)showContactMessage:(NSString *)message;

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

@end

#pragma mark - ContactPermissionPresenterToInteractor

/// Delegates from the presenter (business rules) to the interactor (api/storage)
@protocol ContactPermissionPresenterToInteractor <NSObject>

@required
@property (nonatomic, weak, nullable) id<ContactPermissionInteractorToPresenter> presenter;

/// Store contacts
/// - parameter: contacts The contact list
- (void)storeContacts:(NSArray<CNContact *> *)contacts;

/// Set allowed contacts
- (void)setUserAllowedContacts;

@end

#pragma mark - ContactPermissionPresenterToRouter

/// Delegates from the presenter (business rules) to the router (navigation)
@protocol ContactPermissionPresenterToRouter <NSObject>

@required

/// Initialize and create a module
+ (UIViewController* _Nullable)createModule;

/// Show the next module
- (void)showNextStepFrom:(id<ContactPermissionPresenterToView>)view;

@end

/// Delegates from the view (ui) to the presenter (business rules)
@protocol ContactPermissionViewToPresenter <NSObject>

@required

@property (nonatomic, weak, nullable) id<ContactPermissionPresenterToView> view;
@property (nonatomic, nullable) id<ContactPermissionPresenterToInteractor> interactor;
@property (nonatomic, nullable) id<ContactPermissionPresenterToRouter> router;

/// Callback when view is loaded
- (void)viewDidLoad;

/// Callback when view has appeared
- (void)viewDidAppear;

/// Callback when next button is tapped
- (void)nextButtonTapped;

@end

NS_ASSUME_NONNULL_END
