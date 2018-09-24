//
//  LocationHelper.m
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "LocationHelper.h"
#import "Constants.h"
#import "AppDelegate.h"

#import <CoreLocation/CoreLocation.h>

@interface LocationHelper () <CLLocationManagerDelegate>

@property (nonatomic, nonnull, strong) CLLocationManager *manager;
@property (nonatomic, nonnull, copy) LocationCompletion locationCompletion;

@end

@implementation LocationHelper

/// Current location authorization status
+ (CLAuthorizationStatus)currentStatus {
    return [CLLocationManager authorizationStatus];
}

+ (Location *)userLocation {
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:UserCityKey];
    NSString *country = [[NSUserDefaults standardUserDefaults] objectForKey:UserCountryKey];
    NSManagedObjectContext *managedObjectContext = [[AppDelegate persistentContainer] viewContext];
    NSError *error;
    NSFetchRequest *existingRequest = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    [existingRequest setPredicate:[NSPredicate predicateWithFormat:@"(city == %@) AND (country == %@)", city, country]];
    return [managedObjectContext executeFetchRequest:existingRequest error:&error].firstObject;
}

/// Request location permission and return a location if possible
- (void)askLocationPermission:(LocationCompletion)completion {
    self.locationCompletion = completion;
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [self.manager requestWhenInUseAuthorization];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.manager startUpdatingLocation];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self locationCompletion](nil, status);
        });
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.manager stopUpdatingLocation];
    [self locationCompletion](locations.lastObject, kCLAuthorizationStatusAuthorizedWhenInUse);
}

@end
