//
//  DashboardPresenter.m
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "DashboardPresenter.h"
#import "UIColor+Additions.h"
#import "ContactHelper.h"

#import "Location+CoreDataProperties.h"
#import "Contact+CoreDataProperties.h"

@interface DashboardPresenter ()

@property (nonatomic, strong) NSDate *startFetchDate;
@property (nonatomic, strong) NSDictionary<NSString *, Weather *> *data;

@end

@implementation DashboardPresenter

@synthesize interactor;
@synthesize router;
@synthesize view;

NSString *const currentWeatherKey = @"a_currentWeather";
NSString *const bestCurrentWeatherKey = @"b_bestCurrent";
NSString *const worstCurrentWeatherKey = @"c_worstCurrent";
NSString *const bestNextWeatherKey = @"d_bestNext";
NSString *const worstNextWeatherKey = @"e_worstNext";

- (instancetype)initWithView:(id<DashboardPresenterToView> __nullable)view
                  interactor:(id<DashboardPresenterToInteractor> __nullable)interactor
                      router:(id<DashboardPresenterToRouter> __nullable)router {
    
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        self.router = router;
    }
    return self;
}

#pragma mark - DashboardViewToPresenter

- (void)viewDidLoad {
    [[self view] showWelcomeMessage:NSLocalizedStringFromTable(@"DashboardWelcome", @"OnBoarding", @"")];
    [[self view] showComputing];
    self.startFetchDate = [NSDate date];
    if ([ContactHelper currentStatus] == CNAuthorizationStatusAuthorized) {
        [[self interactor] fetchContactsAndForecastData];
    } else {
        [[self interactor] fetchForecastData];
    }
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return self.data.allKeys.count;
}

- (NSString *)purpose:(NSIndexPath *)indexPath {
    NSArray<NSString *> *sortedKeys = [self.data.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *currentKey = [sortedKeys objectAtIndex:indexPath.row];
    NSString *purpose = @"";
    if ([currentKey isEqualToString:currentWeatherKey]) {
        purpose = NSLocalizedStringFromTable(@"CurrentWeatherPurpose", @"Dashboard", @"");
    } else if ([currentKey isEqualToString:bestCurrentWeatherKey]) {
        purpose = NSLocalizedStringFromTable(@"BestCurrentWeatherPurpose", @"Dashboard", @"");
    } else if ([currentKey isEqualToString:worstCurrentWeatherKey]) {
        purpose = NSLocalizedStringFromTable(@"WorstCurrentWeatherPurpose", @"Dashboard", @"");
    } else if ([currentKey isEqualToString:bestNextWeatherKey]) {
        purpose = NSLocalizedStringFromTable(@"BestNextWeatherPurpose", @"Dashboard", @"");
    } else if ([currentKey isEqualToString:worstNextWeatherKey]) {
        purpose = NSLocalizedStringFromTable(@"WorstNextWeatherPurpose", @"Dashboard", @"");
    }
    return purpose;
}

- (NSString *)info:(NSIndexPath *)indexPath {
    NSArray<NSString *> *sortedKeys = [self.data.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *currentKey = [sortedKeys objectAtIndex:indexPath.row];
    Weather *weather = [self.data objectForKey:currentKey];
    NSString *info = @"";
    NSString *name = [weather.location.contact.fullname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([currentKey isEqualToString:currentWeatherKey]) {
        info = @"";
    } else if ([currentKey isEqualToString:bestCurrentWeatherKey]) {
        info = [NSString stringWithFormat:NSLocalizedStringFromTable(@"InfoBestToday", @"Dashboard", @""), name];
    } else if ([currentKey isEqualToString:worstCurrentWeatherKey]) {
        info = [NSString stringWithFormat:NSLocalizedStringFromTable(@"InfoWorstToday", @"Dashboard", @""), name];
    } else if ([currentKey isEqualToString:bestNextWeatherKey]) {
        info = [NSString stringWithFormat:NSLocalizedStringFromTable(@"InfoBestNext", @"Dashboard", @""), name];
    } else if ([currentKey isEqualToString:worstNextWeatherKey]) {
        info = [NSString stringWithFormat:NSLocalizedStringFromTable(@"InfoWorstNext", @"Dashboard", @""), name];
    }
    
    return info;
}

- (NSAttributedString *)temperatureLocation:(NSIndexPath *)indexPath {
    NSArray<NSString *> *sortedKeys = [self.data.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *currentKey = [sortedKeys objectAtIndex:indexPath.row];
    Weather *weather = [self.data objectForKey:currentKey];
    
    NSString *temp;
    if ([currentKey isEqualToString:currentWeatherKey] ||
        [currentKey isEqualToString:bestCurrentWeatherKey] ||
        [currentKey isEqualToString:worstCurrentWeatherKey]) {
        temp = [NSString stringWithFormat:@"%0.f", weather.currentTemperature];
    } else {
        temp = [NSString stringWithFormat:@"%0.f", weather.nextWeekendTemperature];
    }
    
    NSString *tempLoc = [NSString stringWithFormat:@"%@°\n%@%@", temp ,NSLocalizedStringFromTable(@"Location", @"Dashboard", @""), weather.location.city];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tempLoc];
    [attributedString addAttributes:@{NSForegroundColorAttributeName: UIColor.whiteColor,
                                      NSFontAttributeName: [UIFont fontWithName:@"Montserrat-Medium" size:70]}
                              range:NSMakeRange(0, temp.length)];
    [attributedString addAttributes:@{NSForegroundColorAttributeName: UIColor.whiteColor,
                                      NSFontAttributeName: [UIFont fontWithName:@"Montserrat-Medium" size:70],
                                      NSBaselineOffsetAttributeName: @10}
                              range:NSMakeRange(temp.length, 1)];
    [attributedString addAttributes:@{NSForegroundColorAttributeName: UIColor.whiteColor,
                                      NSFontAttributeName: [UIFont fontWithName:@"Montserrat-Medium" size:25]}
                              range:NSMakeRange(temp.length + 2, [NSLocalizedStringFromTable(@"Location", @"Dashboard", @"") stringByAppendingString:weather.location.city].length)];
    return attributedString;
}

- (UIImage *)image:(NSIndexPath *)indexPath {
    NSArray<NSString *> *sortedKeys = [self.data.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *currentKey = [sortedKeys objectAtIndex:indexPath.row];
    Weather *weather = [self.data objectForKey:currentKey];
    
    NSString *icon;
    if ([currentKey isEqualToString:currentWeatherKey] ||
        [currentKey isEqualToString:bestCurrentWeatherKey] ||
        [currentKey isEqualToString:worstCurrentWeatherKey]) {
        icon = weather.currentIcon;
    } else {
        icon = weather.nextWeekendIcon;
    }
    
    UIImage *image;
    if ([icon isEqualToString:@"clear-day"]) {
        image = [UIImage imageNamed:@"sunny"];
    } else if ([icon isEqualToString:@"clear-night"]) {
        image = [UIImage imageNamed:@"clear-night"];
    } else if ([icon isEqualToString:@"rain"]) {
        image = [UIImage imageNamed:@"rain"];
    } else if ([icon isEqualToString:@"snow"]) {
        image = [UIImage imageNamed:@"rain"];
    } else if ([icon isEqualToString:@"sleet"]) {
        image = [UIImage imageNamed:@"rain"];
    } else if ([icon isEqualToString:@"wind"]) {
        image = [UIImage imageNamed:@"cloud"];
    } else if ([icon isEqualToString:@"fog"]) {
        image = [UIImage imageNamed:@"cloud"];
    } else if ([icon isEqualToString:@"cloudy"]) {
        image = [UIImage imageNamed:@"cloud"];
    } else if ([icon isEqualToString:@"partly-cloudy-day"]) {
        image = [UIImage imageNamed:@"partly-cloudy-day"];
    } else if ([icon isEqualToString:@"partly-cloudy-night"]) {
        image = [UIImage imageNamed:@"partly-cloudy-night"];
    } else if ([icon isEqualToString:@"hail"]) {
        image = [UIImage imageNamed:@"thunder"];
    } else if ([icon isEqualToString:@"thunderstorm"]) {
        image = [UIImage imageNamed:@"thunder"];
    } else if ([icon isEqualToString:@"tornado"]) {
        image = [UIImage imageNamed:@"thunder"];
    } else {
        image = nil;
    }
    
    return image;
}

- (UIColor *)shadowColor:(NSIndexPath *)indexPath {
    NSArray<NSString *> *sortedKeys = [self.data.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *currentKey = [sortedKeys objectAtIndex:indexPath.row];
    Weather *weather = [self.data objectForKey:currentKey];
    
    NSString *icon;
    if ([currentKey isEqualToString:currentWeatherKey] ||
        [currentKey isEqualToString:bestCurrentWeatherKey] ||
        [currentKey isEqualToString:worstCurrentWeatherKey]) {
        icon = weather.currentIcon;
    } else {
        icon = weather.nextWeekendIcon;
    }
    
    UIColor *color;
    if ([icon isEqualToString:@"clear-day"]) {
        color = [UIColor sunnyColor];
    } else if ([icon isEqualToString:@"clear-night"]) {
        color = [UIColor clearNightColor];
    } else if ([icon isEqualToString:@"rain"]) {
        color = [UIColor rainyColor];
    } else if ([icon isEqualToString:@"snow"]) {
        color = [UIColor rainyColor];
    } else if ([icon isEqualToString:@"sleet"]) {
        color = [UIColor rainyColor];
    } else if ([icon isEqualToString:@"wind"]) {
        color = [UIColor cloudyColor];
    } else if ([icon isEqualToString:@"fog"]) {
        color = [UIColor cloudyColor];
    } else if ([icon isEqualToString:@"cloudy"]) {
        color = [UIColor cloudyColor];
    } else if ([icon isEqualToString:@"partly-cloudy-day"]) {
        color = [UIColor partialCloudyColor];
    } else if ([icon isEqualToString:@"partly-cloudy-night"]) {
        color = [UIColor cloudyNightColor];
    } else if ([icon isEqualToString:@"hail"]) {
        color = [UIColor thunderColor];
    } else if ([icon isEqualToString:@"thunderstorm"]) {
        color = [UIColor thunderColor];
    } else if ([icon isEqualToString:@"tornado"]) {
        color = [UIColor thunderColor];
    } else {
        color = [UIColor blackColor];
    }
    
    return color;
}

#pragma mark - DashboardInteractorToPresenter

- (void)currentWeather:(Weather * _Nullable)currentWeather bestCurrent:(Weather * _Nullable)bestCurrent worstCurrent:(Weather * _Nullable)worstCurrent bestNext:(Weather * _Nullable)bestNext worstNext:(Weather * _Nullable)worstNext {

    // Store data in a dictionary
    NSMutableDictionary *data = [NSMutableDictionary new];
    if (currentWeather) {
        [data setObject:currentWeather forKey:currentWeatherKey];
    }
    if (bestCurrent) {
        [data setObject:bestCurrent forKey:bestCurrentWeatherKey];
    }
    if (worstCurrent) {
        [data setObject:worstCurrent forKey:worstCurrentWeatherKey];
    }
    if (bestNext) {
        [data setObject:bestNext forKey:bestNextWeatherKey];
    }
    if (worstNext) {
        [data setObject:worstNext forKey:worstNextWeatherKey];
    }
    
    self.data = data;
    
    // UI Trick : we want to let the animation a bit if too fast.
    NSDate *endFetchDate = [NSDate date];
    NSTimeInterval fetchTime = [endFetchDate timeIntervalSinceDate:self.startFetchDate];
    NSTimeInterval minimumTimeToFetch = 2.5 - fetchTime;
    if (minimumTimeToFetch > 0.f) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(minimumTimeToFetch * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[self view] hideComputing];
            [[self view] reloadData];
        });
    } else {
        [[self view] hideComputing];
        [[self view] reloadData];
    }
}

- (void)fetchContactsAndForecastDataFinished {
    [[self interactor] getDashboardData];
}

- (void)getForecastError:(nonnull NSString *)city country:(nonnull NSString *)country {
    // TODO:
    NSLog(@"Couldn't get forecast for %@, %@", city, country);
}

- (void)commonStorageError {
    // TODO:
    NSLog(@"Storage error...");
}

@end
