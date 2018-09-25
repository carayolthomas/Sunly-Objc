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

/// Delegate from the interactor (api/storage) to the presenter (business rules)
@protocol DashboardInteractorToPresenter <NSObject>

/// Called when dashboard data asked.
/// - parameter: currentWeather The connected user current forecast
/// - parameter: bestCurrent The best current forecast in the users contacts
/// - parameter: worstCurrent The worst current forecast in the users contacts
/// - parameter: bestNext The best next weekend forecast in the users contacts
/// - parameter: worstNext The worst next weekend forecast in the users contacts
- (void)currentWeather:(Weather * __nullable)currentWeather bestCurrent:(Weather *__nullable)bestCurrent worstCurrent:(Weather *__nullable)worstCurrent bestNext:(Weather *__nullable)bestNext worstNext:(Weather *__nullable)worstNext;

/// Called when fetching data has finished
- (void)fetchContactsAndForecastDataFinished;

/// Called when a storage error came up
- (void)commonStorageError;

/// Called when an error occured while retrieve forecast
/// - parameter: city The forecast city
/// - parameter: country The forecast country
- (void)getForecastError:(NSString *)city country:(NSString *)country;

@end

#pragma mark - DashboardPresenterToView

/// Delegate from the presenter (business rules) to the view (ui)
@protocol DashboardPresenterToView <NSObject>

@required

/// Shows a welcome message at the top of the view
/// - parameter: message The message
- (void)showWelcomeMessage:(NSString *)message;

/// Show computing animation
- (void)showComputing;

/// Hide computing animation
- (void)hideComputing;

/// Reload the dashboard data
- (void)reloadData;

@end

#pragma mark - DashboardPresenterToInteractor

/// Delegate from the presenter (business rules) to the interactor (api/storage)
@protocol DashboardPresenterToInteractor <NSObject>

@required
@property (nonatomic, weak, nullable) id<DashboardInteractorToPresenter> presenter;

/// Fetch forecast from API
- (void)fetchForecastData;

/// Fetch contacts from address book and then fetch forecast from API
- (void)fetchContactsAndForecastData;

/// Compute dashboard data from storage
- (void)getDashboardData:(NSPersistentContainer *)persistantContainer userDefaults:(NSUserDefaults *)userDefaults;

@end

#pragma mark - DashboardPresenterToRouter

/// Delegate from the presenter (business rules) to the router (navigation)
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

/// Return the number of sections needed
- (NSInteger)numberOfSections;

/// Return the number of rows for a given section
/// - parameter: section The section index
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

/// Return the purpose of the cell. Something like "Today", "Best today forecast", ...
/// - parameter: indexPath
- (NSString *)purpose:(NSIndexPath *)indexPath;

/// Return the some info about the weather and the contact
/// - parameter: indexPath
- (NSString *)info:(NSIndexPath *)indexPath;

/// Return the temperature for a location
/// - parameter: indexPath
- (NSAttributedString *)temperatureLocation:(NSIndexPath *)indexPath;

/// Return the background image
/// - parameter: indexPath
- (UIImage *__nullable)image:(NSIndexPath *)indexPath;

/// Return the shadow color
/// - parameter: indexPath
- (UIColor *)shadowColor:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
