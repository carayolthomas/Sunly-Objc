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

#import <CoreLocation/CoreLocation.h>

@implementation DashboardInteractor

@synthesize presenter;

- (void)computeData {
    
    NSManagedObjectContext *managedObjectContext = [[AppDelegate persistentContainer] viewContext];
    
    NSError *error;
    NSFetchRequest *existingRequest = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    NSArray<Location *> *locations = [managedObjectContext executeFetchRequest:existingRequest error:&error];
    
    if (error) {
        NSLog(@"Error");
        return;
    }
    
    for (Location *location in locations) {
        if (location.coordinate) {
            [self getForecast:location.city country:location.country key:@"a7d0b3b63b8de23058d6ce9e4bf77ec2" coordinate:location.coordinate exclude:@[@"minutely", @"hourly", @"alerts", @"flags"] language:@"fr" units:@"si"];
        }
    }
}

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
    
    __weak DashboardInteractor *weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.presenter getForecastError];
            });
        } else {
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf handleForecast:data city:city country:country];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.presenter getForecastError];
                });
            }
        }
        
    }] resume];
}

- (void)handleForecast:(NSData *)data city:(NSString *)city country:(NSString *)country {
    
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error) {
        [[self presenter] getForecastError];
        return;
    }
    
    NSManagedObjectContext *managedObjectContext = [[AppDelegate persistentContainer] viewContext];
    
    NSFetchRequest *existingRequest = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    [existingRequest setPredicate:[NSPredicate predicateWithFormat:@"(city == %@) AND (country == %@)", city, country]];
    Location *existingLocation = [managedObjectContext executeFetchRequest:existingRequest error:&error].firstObject;
    
    if (!existingLocation) {
        NSLog(@"Location not found");
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
    
    NSLog(@"SAVED!");
}

- (void)update:(Weather *)weather with:(NSDictionary *)dictionary {
    weather.currentIcon = [[dictionary objectForKey:@"currently"] objectForKey:@"icon"];
    weather.currentPrecip = [[[dictionary objectForKey:@"currently"] objectForKey:@"precipProbability"] doubleValue];
    weather.currentTemperature = [[[dictionary objectForKey:@"currently"] objectForKey:@"temperature"] doubleValue];
    
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
    // Just handle last for the moment...
    NSDictionary *lastWeekendDay = nextWeekendDays.lastObject;
    weather.nextWeekendIcon = [lastWeekendDay objectForKey:@"icon"];
    weather.nextWeekendPrecip = [[lastWeekendDay objectForKey:@"precipProbability"] doubleValue];
    weather.nextWeekendTemperature = [[lastWeekendDay objectForKey:@"temperature"] doubleValue];
}

@end
