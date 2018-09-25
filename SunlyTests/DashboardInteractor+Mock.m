//
//  DashboardInteractor+Mock.m
//  SunlyTests
//
//  Created by Thomas Carayol on 25/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "DashboardInteractor+Mock.h"
#import "Contact+CoreDataProperties.h"
#import "Location+CoreDataProperties.h"
#import "Weather+CoreDataProperties.h"

@implementation MockDashboardInteractor

@synthesize presenter;

- (void)fetchContactsAndForecastData {
    
    // 5 mock contacts
    
    [self insertMockContact:@"Thomas" identifier:@"1" persistentContainer:<#(nonnull NSPersistentContainer *)#>]
    
}

- (void)fetchForecastData {
    
}

- (void)getDashboardData:(nonnull NSPersistentContainer *)persistantContainer userDefaults:(nonnull NSUserDefaults *)userDefaults {
    
}

#pragma mark - Helper

- (Contact *)insertMockContact:(NSString *)fullname identifier:(NSString *)identifier persistentContainer:(nonnull NSPersistentContainer *)persistantContainer {
    
    Contact *mock = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:persistantContainer.viewContext];
    
    mock.fullname = fullname;
    mock.identifier = identifier;
    
    return mock;
}

- (Location *)insertMockLocation:(NSString *)city coordinate:(NSString *)coordinate country:(NSString *)country persistentContainer:(nonnull NSPersistentContainer *)persistantContainer {
    
    Location *mock = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:persistantContainer.viewContext];
    
    mock.city = city;
    mock.country = country;
    mock.coordinate = coordinate;
    
    return mock;
}

- (Weather *)insertMockWeather:(NSString *)currentIcon currentPrecip:(double)currentPrecip currentScore:(double)currentScore currentTemp:(double)currentTemp nwIcon:(NSString *)nwIcon nwPrecip:(double)nwPrecip nwScore:(double)nwScore nwTemp:(double)nwTemp persistentContainer:(nonnull NSPersistentContainer *)persistantContainer {
    
    Weather *mock = [NSEntityDescription insertNewObjectForEntityForName:@"Weather" inManagedObjectContext:persistantContainer.viewContext];
    
    mock.currentIcon = currentIcon;
    mock.currentPrecip = currentPrecip;
    mock.currentScore = currentScore;
    mock.currentTemperature = currentTemp;
    mock.nextWeekendIcon = nwIcon;
    mock.nextWeekendScore = nwScore;
    mock.nextWeekendTemperature = nwTemp;
    mock.nextWeekendPrecip = nwPrecip;
    
    return mock;
}

@end
