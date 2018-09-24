//
//  XCUIApplication+Sunly.h
//  SunlyUITests
//
//  Created by Thomas Carayol on 24/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import <XCTest/XCTest.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCUIApplication (Sunly)

- (BOOL)isDisplayingContactsPermission;
- (XCUIElement *)contactAllowButton;

- (BOOL)isDisplayingLocationPermission;
- (XCUIElement *)locationAllowButton;

- (BOOL)isDisplayingDashboard;

@end

NS_ASSUME_NONNULL_END
