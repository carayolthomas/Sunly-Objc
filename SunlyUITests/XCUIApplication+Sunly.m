//
//  XCUIApplication+Sunly.m
//  SunlyUITests
//
//  Created by Thomas Carayol on 24/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCUIApplication+Sunly.h"

@implementation XCUIApplication (Sunly)

- (BOOL)isDisplayingContactsPermission {
    return [[[self buttons] objectForKeyedSubscript:@"contactAllowButtonIdentifier"] exists];
}

- (XCUIElement *)contactAllowButton {
    return [[self buttons] objectForKeyedSubscript:@"contactAllowButtonIdentifier"];
}

- (BOOL)isDisplayingLocationPermission {
    return [[[self buttons] objectForKeyedSubscript:@"locationAllowButtonIdentifier"] exists];
}

- (XCUIElement *)locationAllowButton {
    return [[self buttons] objectForKeyedSubscript:@"locationAllowButtonIdentifier"];
}

- (BOOL)isDisplayingDashboard {
    return [[[self collectionViews] objectForKeyedSubscript:@"Shadow"] exists];
}

@end
