//
//  LocationPermissionInteractor.m
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "LocationPermissionInteractor.h"
#import "Constants.h"

@implementation LocationPermissionInteractor

@synthesize presenter;

- (void)storeUserCoordinate:(NSString *)coordinate {
    [[NSUserDefaults standardUserDefaults] setObject:coordinate forKey:UserCoordinateKey];
}

- (void)setUserAllowedLocation {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UserAllowedLocationKey];
}

@end
