//
//  LocationPermissionPresenter.m
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "LocationPermissionPresenter.h"
#import "UIColor+Additions.h"
#import "LocationHelper.h"
#import "AppDelegate.h"
#import "Constants.h"

#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>

@interface LocationPermissionPresenter ()

@property (nonatomic, nonnull, strong) LocationHelper *helper;

@end

@implementation LocationPermissionPresenter

@synthesize interactor;
@synthesize router;
@synthesize view;

- (instancetype)initWithView:(id<LocationPermissionPresenterToView> __nullable)view
                  interactor:(id<LocationPermissionPresenterToInteractor> __nullable)interactor
                      router:(id<LocationPermissionPresenterToRouter> __nullable)router {
    
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        self.router = router;
    }
    return self;
}

#pragma mark - LocationPermissionViewToPresenter

- (void)nextButtonTapped {
    [[self view] disableNextButton];
    [[self view] configureSearching];
    [self requestLocation];
}

- (void)viewDidLoad {
    [[self view] configureBackgroundColor:[UIColor skyBlueColor]];
    [[self view] showLocationImageView:[UIImage imageNamed:@"location"]];
    NSString *userGivenName = [[NSUserDefaults standardUserDefaults] objectForKey:UserGivenNameKey];
    if (userGivenName) {
        [[self view] showWelcomeMessage:[NSString stringWithFormat:NSLocalizedStringFromTable(@"LocationPermissionWelcomeFormat", @"OnBoarding", @""), userGivenName]];
    } else {
        [[self view] showWelcomeMessage:[NSString stringWithFormat:NSLocalizedStringFromTable(@"LocationPermissionWelcome", @"OnBoarding", @"")]];
    }
    [[self view] showLocationMessage:NSLocalizedStringFromTable(@"LocationPermissionInfo", @"OnBoarding", @"")];
    [[self view] configureNextButton:NSLocalizedStringFromTable(@"LocationPermissionAction", @"OnBoarding", @"")];
}

- (void)viewDidAppear {
    __weak LocationPermissionPresenter *weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:nil usingBlock:^(NSNotification * __nonnull note) {
        [weakSelf handleLocationAuthorizationStatus:[LocationHelper currentStatus] with:nil];
    }];
}

- (void)handleLocationAuthorizationStatus:(CLAuthorizationStatus)status with:(CLLocation *)location {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self locationAuthorizedBehavior:location];
    } else if (status == kCLAuthorizationStatusRestricted) {
        [self locationRestrictedBehavior];
    } else if (status == kCLAuthorizationStatusDenied) {
        [self locationDeniedBehavior];
    }
}

- (void)locationAuthorizedBehavior:(CLLocation *)location {
    if (location) {
        [[self interactor] storeUserCoordinate:[NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude]];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [[self router] showNextStepFrom:self.view];
        });
    } else {
        [[self view] disableNextButton];
        [[self view] configureSearching];
        [self requestLocation];
    }
}

- (void)locationRestrictedBehavior {
    [[self view] enableNextButton];
    [[self view] showAlertWith:NSLocalizedStringFromTable(@"LocationPermissionRestrictedTitle", @"OnBoarding", @"") and:NSLocalizedStringFromTable(@"LocationPermissionRestrictedMessage", @"OnBoarding", @"")];
}

- (void)locationDeniedBehavior {
    [[self view] enableNextButton];
    [[self view] showSettingsAlertWith:NSLocalizedStringFromTable(@"LocationPermissionDeniedTitle", @"OnBoarding", @"") and:NSLocalizedStringFromTable(@"LocationPermissionDeniedMessage", @"OnBoarding", @"")];
}

- (void)dealloc {
    NSLog(@"dealloc");
}

#pragma mark - Location

- (void)requestLocation {
    __weak LocationPermissionPresenter *weakSelf = self;
    self.helper = [[LocationHelper alloc] init];
    [self.helper askLocationPermission:^(CLLocation * _Nullable location, CLAuthorizationStatus status) {
        [weakSelf handleLocationAuthorizationStatus:status with:location];
    }];
}

@end
