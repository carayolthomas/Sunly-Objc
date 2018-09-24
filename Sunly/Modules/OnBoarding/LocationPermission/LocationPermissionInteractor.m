//
//  LocationPermissionInteractor.m
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "LocationPermissionInteractor.h"
#import "Constants.h"

#import <CoreLocation/CoreLocation.h>

@implementation LocationPermissionInteractor

@synthesize presenter;

- (void)storeUserCoordinate:(NSString *)coordinate {
    
    // Store user coordinate
    [[NSUserDefaults standardUserDefaults] setObject:coordinate forKey:UserCoordinateKey];
    
    // Fetch city and country
    double latitude = [[[coordinate componentsSeparatedByString:@","] firstObject] doubleValue];
    double longitude = [[[coordinate componentsSeparatedByString:@","] lastObject] doubleValue];

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    __weak LocationPermissionInteractor *weakSelf = self;
    [geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            [[weakSelf presenter] userLocationStoredError];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:placemarks.firstObject.locality forKey:UserCityKey];
            [[NSUserDefaults standardUserDefaults] setObject:placemarks.firstObject.country forKey:UserCountryKey];
            [[weakSelf presenter] userLocationStoredSuccess];
        }
    }];
}

- (void)setUserAllowedLocation {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UserAllowedLocationKey];
}

@end
