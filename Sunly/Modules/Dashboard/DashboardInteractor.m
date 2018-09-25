//
//  DashboardInteractor.m
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "DashboardInteractor.h"
#import "AppDelegate.h"
#import "Contact+CoreDataProperties.h"
#import "Location+CoreDataProperties.h"
#import "Weather+CoreDataProperties.h"
#import "ContactHelper.h"
#import "LocationHelper.h"
#import "Constants.h"

#import <CoreLocation/CoreLocation.h>

typedef void(^FetchDataCompletion)(BOOL finished);

@interface DashboardInteractor ()

@property (nonatomic, strong) dispatch_group_t dispatchGroup;

@end

@implementation DashboardInteractor

@synthesize presenter;

- (void)fetchForecastData:(NSPersistentContainer *)persistantContainer userDefaults:(NSUserDefaults *)userDefaults {
    __weak DashboardInteractor *weakSelf = self;
    [self fetchData:NO completion:^(BOOL finished) {
        [[weakSelf presenter] fetchContactsAndForecastDataFinished];
    }];
}

- (void)fetchContactsAndForecastData:(NSPersistentContainer *)persistantContainer userDefaults:(NSUserDefaults *)userDefaults {
    __weak DashboardInteractor *weakSelf = self;
    [self fetchData:YES completion:^(BOOL finished) {
        [[weakSelf presenter] fetchContactsAndForecastDataFinished];
    }];
}

- (void)getDashboardData:(NSPersistentContainer *)persistantContainer userDefaults:(NSUserDefaults *)userDefaults {
    
    Weather *current = [self getUserCurrentForecast:userDefaults persistentContainer:persistantContainer];
    Weather *bestCurrent = [self getBestCurrentForecast:persistantContainer];
    Weather *worstCurrent = [self getWorstCurrentForecast:persistantContainer];
    Weather *bestNext = [self getBestNextWeekendForecast:persistantContainer];
    Weather *worstNext = [self getWorstNextWeekendForecast:persistantContainer];
    
    [[self presenter] currentWeather:current bestCurrent:bestCurrent worstCurrent:worstCurrent bestNext:bestNext worstNext:worstNext];
}

#pragma mark - Private

- (Weather *)getUserCurrentForecast:(NSUserDefaults *)userDefaults persistentContainer:(NSPersistentContainer *)persistentContainer {
    return [LocationHelper userLocation:userDefaults persistentContainer:persistentContainer].weather;
}

- (Weather *)getBestCurrentForecast:(NSPersistentContainer *)persistantContainer {
    NSError *error;
    NSManagedObjectContext *managedObjectContext = [persistantContainer viewContext];
    NSFetchRequest *weatherRequest = [NSFetchRequest fetchRequestWithEntityName:@"Weather"];
    [weatherRequest setFetchLimit:1];
    NSSortDescriptor *sortScore = [NSSortDescriptor sortDescriptorWithKey:@"currentScore" ascending:NO];
    [weatherRequest setSortDescriptors:@[sortScore]];
    NSArray<Weather *> *weather = [managedObjectContext executeFetchRequest:weatherRequest error:&error];
    return weather.firstObject;
}

- (Weather *)getWorstCurrentForecast:(NSPersistentContainer *)persistantContainer {
    NSError *error;
    NSManagedObjectContext *managedObjectContext = [persistantContainer viewContext];
    NSFetchRequest *weatherRequest = [NSFetchRequest fetchRequestWithEntityName:@"Weather"];
    [weatherRequest setFetchLimit:1];
    NSSortDescriptor *sortScore = [NSSortDescriptor sortDescriptorWithKey:@"currentScore" ascending:YES];
    [weatherRequest setSortDescriptors:@[sortScore]];
    NSArray<Weather *> *weather = [managedObjectContext executeFetchRequest:weatherRequest error:&error];
    return weather.firstObject;
}

- (Weather *)getBestNextWeekendForecast:(NSPersistentContainer *)persistantContainer {
    NSError *error;
    NSManagedObjectContext *managedObjectContext = [persistantContainer viewContext];
    NSFetchRequest *weatherRequest = [NSFetchRequest fetchRequestWithEntityName:@"Weather"];
    [weatherRequest setFetchLimit:1];
    NSSortDescriptor *sortScore = [NSSortDescriptor sortDescriptorWithKey:@"nextWeekendScore" ascending:NO];
    [weatherRequest setSortDescriptors:@[sortScore]];
    NSArray<Weather *> *weather = [managedObjectContext executeFetchRequest:weatherRequest error:&error];
    return weather.firstObject;
}

- (Weather *)getWorstNextWeekendForecast:(NSPersistentContainer *)persistantContainer {
    NSError *error;
    NSManagedObjectContext *managedObjectContext = [persistantContainer viewContext];
    NSFetchRequest *weatherRequest = [NSFetchRequest fetchRequestWithEntityName:@"Weather"];
    [weatherRequest setFetchLimit:1];
    NSSortDescriptor *sortScore = [NSSortDescriptor sortDescriptorWithKey:@"nextWeekendScore" ascending:YES];
    [weatherRequest setSortDescriptors:@[sortScore]];
    NSArray<Weather *> *weather = [managedObjectContext executeFetchRequest:weatherRequest error:&error];
    return weather.firstObject;
}

/// Fetch dashboard needed data
/// 1. Fetch and store contacts
/// 2. Get forecast for each contact location
- (void)fetchData:(BOOL)shouldFetchContact completion:(FetchDataCompletion)completion {
    
    if (shouldFetchContact) {
        [self fetchAndStoreContacts];
    }
    
    NSArray<Location *> *contactsLocation = [self fetchContactsLocation];
    Location *userLocation = [LocationHelper userLocation:[NSUserDefaults standardUserDefaults] persistentContainer:[AppDelegate persistentContainer]];
    
    [self getForecast:contactsLocation userLocation:userLocation completion:completion];
}

#pragma mark - Helper functions

/// Fetch contacts from AddressBook and store them in CoreData
- (void)fetchAndStoreContacts {
    NSManagedObjectContext *managedObjectContext = [[AppDelegate persistentContainer] viewContext];
    NSArray<CNContact *> *contacts = [ContactHelper fetchContactWithAddress];
    [ContactHelper store:contacts with:managedObjectContext];
}

/// Retrieve stored contacts location
- (NSArray<Location *> *)fetchContactsLocation {
    NSError *error;
    NSManagedObjectContext *managedObjectContext = [[AppDelegate persistentContainer] viewContext];
    NSFetchRequest *existingRequest = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    NSArray<Location *> *locations = [managedObjectContext executeFetchRequest:existingRequest error:&error];
    
    if (error) {
        [self.presenter commonStorageError];
        return nil;
    }
    
    return locations;
}

/// Fetch the forecast for each location
/// TODO: We should set the key in CI for dynamic biding at compile time
- (void)getForecast:(NSArray<Location *> *)contactsLocation userLocation:(Location *)userLocation completion:(FetchDataCompletion)completion {
    
    self.dispatchGroup = dispatch_group_create();
    
    NSString *key = @"a7d0b3b63b8de23058d6ce9e4bf77ec2";
    NSArray *exclude = @[@"minutely", @"hourly", @"alerts", @"flags"];
    NSString *language = @"fr";
    NSString *units = @"si";
    
    if (contactsLocation) {
        for (Location *location in contactsLocation) {
            if (location.coordinate) {
                [self getForecast:location.city country:location.country key:key coordinate:location.coordinate exclude:exclude language:language units:units];
            }
        }
    }
    
    if (userLocation) {
        [self getForecast:userLocation.city country:userLocation.country key:key coordinate:userLocation.coordinate exclude:exclude language:language units:units];
    }
    
    dispatch_group_wait(self.dispatchGroup, 20.f);
    dispatch_group_notify(self.dispatchGroup, dispatch_get_main_queue(), ^{
        completion(true);
    });
}

/// Create an `NSURLRequest` to retrieve forecast for each location
- (void)getForecast:(NSString *)city country:(NSString *)country key:(NSString *)key coordinate:(NSString *)coordinate exclude:(NSArray *)exclude language:(NSString *)language units:(NSString *)units {
    
    NSURLQueryItem *excludeQueryItem = [NSURLQueryItem queryItemWithName:@"exclude" value:[exclude componentsJoinedByString:@","]];
    NSURLQueryItem *languageQueryItem = [NSURLQueryItem queryItemWithName:@"language" value:language];
    NSURLQueryItem *unitsQueryItem = [NSURLQueryItem queryItemWithName:@"units" value:units];
    
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"https";
    components.host = @"api.darksky.net";
    components.path = [NSString stringWithFormat:@"/forecast/%@/%@", key, coordinate];
    components.queryItems = @[excludeQueryItem, languageQueryItem, unitsQueryItem];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:components.URL];
    
    dispatch_group_enter(self.dispatchGroup);
    
    __weak DashboardInteractor *weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.presenter getForecastError:city country:country];
            });
        } else {
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf handleForecast:data city:city country:country];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.presenter getForecastError:city country:country];
                });
            }
        }
        
        dispatch_group_leave(self.dispatchGroup);
        
    }] resume];
}

/// Parse and store retrieved forecast data
- (void)handleForecast:(NSData *)data city:(NSString *)city country:(NSString *)country {
    
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error) {
        [[self presenter] getForecastError:city country:country];
        return;
    }
    
    NSManagedObjectContext *managedObjectContext = [[AppDelegate persistentContainer] viewContext];
    
    NSFetchRequest *existingRequest = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    [existingRequest setPredicate:[NSPredicate predicateWithFormat:@"(city == %@) AND (country == %@)", city, country]];
    Location *existingLocation = [managedObjectContext executeFetchRequest:existingRequest error:&error].firstObject;
    
    if (!existingLocation) {
        [[self presenter] commonStorageError];
        return;
    }
    
    if (existingLocation.weather) {
        [self update:existingLocation.weather with:dictionary];
    } else {
        existingLocation.weather = [NSEntityDescription insertNewObjectForEntityForName:@"Weather" inManagedObjectContext:managedObjectContext];
        [self update:existingLocation.weather with:dictionary];
    }
    
    if ([managedObjectContext save:&error] == NO) {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}

/// Update a weather `NSManagedObject` with data.
/// Retrieve the current forecast and the next weekend last day forecast.
/// TODO: Retrieve both weekend days and not only Sunday.
- (void)update:(Weather *)weather with:(NSDictionary *)dictionary {
    
    // Set current forecast
    weather.currentIcon = [[dictionary objectForKey:@"currently"] objectForKey:@"icon"];
    weather.currentPrecip = [[[dictionary objectForKey:@"currently"] objectForKey:@"precipProbability"] doubleValue];
    weather.currentTemperature = [[[dictionary objectForKey:@"currently"] objectForKey:@"temperature"] doubleValue];
    weather.currentScore = [self computeWeatherScore:weather.currentIcon precip:weather.currentPrecip temperature:weather.currentTemperature];
    
    // Check for the last weekend day
    NSArray *nextDays = [[dictionary objectForKey:@"daily"] objectForKey:@"data"];
    NSPredicate *weekendDaysPredicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        NSDate *dailyDate = [NSDate dateWithTimeIntervalSince1970:[[evaluatedObject objectForKey:@"time"] doubleValue]];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSRange weekdayRange = [calendar maximumRangeOfUnit:NSCalendarUnitWeekday];
        NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:dailyDate];
        NSUInteger weekdayOfDate = [components weekday];
        return (weekdayOfDate == weekdayRange.location || weekdayOfDate == weekdayRange.length);
    }];
    NSArray *nextWeekendDays = [nextDays filteredArrayUsingPredicate:weekendDaysPredicate];
    NSDictionary *lastWeekendDay = nextWeekendDays.lastObject;
    
    // Set last weekend day forecast
    weather.nextWeekendIcon = [lastWeekendDay objectForKey:@"icon"];
    weather.nextWeekendPrecip = [[lastWeekendDay objectForKey:@"precipProbability"] doubleValue];
    weather.nextWeekendTemperature = [[lastWeekendDay objectForKey:@"temperatureHigh"] doubleValue];
    weather.nextWeekendScore = [self computeWeatherScore:weather.nextWeekendIcon precip:weather.nextWeekendPrecip temperature:weather.nextWeekendTemperature];
}

- (double)computeWeatherScore:(NSString *)icon precip:(double)precip temperature:(double)temperature {
    
    double score = 0.f;
    
    // icon
    
    if ([icon isEqualToString:@"clear-day"]) {
        score = 50;
    } else if ([icon isEqualToString:@"clear-night"]) {
        score = 50;
    } else if ([icon isEqualToString:@"rain"]) {
        score = 20;
    } else if ([icon isEqualToString:@"snow"]) {
        score = 10;
    } else if ([icon isEqualToString:@"sleet"]) {
        score = 10;
    } else if ([icon isEqualToString:@"wind"]) {
        score = 35;
    } else if ([icon isEqualToString:@"fog"]) {
        score = 25;
    } else if ([icon isEqualToString:@"cloudy"]) {
        score = 30;
    } else if ([icon isEqualToString:@"partly-cloudy-day"]) {
        score = 40;
    } else if ([icon isEqualToString:@"partly-cloudy-night"]) {
        score = 40;
    } else if ([icon isEqualToString:@"hail"]) {
        score = 10;
    } else if ([icon isEqualToString:@"thunderstorm"]) {
        score = 5;
    } else if ([icon isEqualToString:@"tornado"]) {
        score = 5;
    } else {
        score = 1;
    }
    
    // precip
    
    if (precip > 0.f) {
        score = score / (precip * 100);
    }
    
    // temperature
    
    score = score * (temperature / 10);
    
    return score;
}

@end
