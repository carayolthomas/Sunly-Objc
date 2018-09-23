//
//  DashboardProtocols.h
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Weather+CoreDataProperties.h"

@import Contacts;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - DashboardInteractorToPresenter

/// Delegates from the interactor (api/storage) to the presenter (business rules)
@protocol DashboardInteractorToPresenter <NSObject>

- (void)currentWeather:(Weather * __nullable)currentWeather bestCurrent:(Weather *__nullable)bestCurrent worstCurrent:(Weather *__nullable)worstCurrent bestNext:(Weather *__nullable)bestNext worstNext:(Weather *__nullable)worstNext;
- (void)fetchContactsAndForecastDataFinished;
- (void)commonStorageError;
- (void)getForecastError:(NSString *)city country:(NSString *)country;

@end

#pragma mark - DashboardPresenterToView

/// Delegates from the presenter (business rules) to the view (ui)
@protocol DashboardPresenterToView <NSObject>

@required

/// Shows a welcome message at the top of the view
/// - parameter: message The message
- (void)showWelcomeMessage:(NSString *)message;

- (void)showComputing;
- (void)hideComputing;

@end

#pragma mark - DashboardPresenterToInteractor

/// Delegates from the presenter (business rules) to the interactor (api/storage)
@protocol DashboardPresenterToInteractor <NSObject>

@required
@property (nonatomic, weak, nullable) id<DashboardInteractorToPresenter> presenter;

- (void)fetchContactsAndForecastData;
- (void)getDashboardData;

@end

#pragma mark - DashboardPresenterToRouter

/// Delegates from the presenter (business rules) to the router (navigation)
@protocol DashboardPresenterToRouter <NSObject>

@required

/// Initialize and create a module
+ (UIViewController* _Nullable)createModule;

@end

/// Delegates from the view (ui) to the presenter (business rules)
@protocol DashboardViewToPresenter <NSObject>

@required

@property (nonatomic, weak, nullable) id<DashboardPresenterToView> view;
@property (nonatomic, nullable) id<DashboardPresenterToInteractor> interactor;
@property (nonatomic, nullable) id<DashboardPresenterToRouter> router;

/// Callback when view is loaded
- (void)viewDidLoad;

@end

NS_ASSUME_NONNULL_END
