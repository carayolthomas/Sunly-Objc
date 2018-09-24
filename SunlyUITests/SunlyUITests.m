//
//  SunlyUITests.m
//  SunlyUITests
//
//  Created by Thomas Carayol on 21/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCUIApplication+Sunly.h"

@interface SunlyUITests : XCTestCase

@property (nonatomic, strong) XCUIApplication *app;

@end

@implementation SunlyUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    self.app = [[XCUIApplication alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testAllowFlow {
    
    [self.app launch];
    
    XCTAssertTrue([self.app isDisplayingContactsPermission]);

    [[self.app contactAllowButton] tap];
    
    [self addUIInterruptionMonitorWithDescription:@"Contacts" handler:^BOOL(XCUIElement * _Nonnull interruptingElement) {
        [[[interruptingElement buttons] objectForKeyedSubscript:@"OK"] tap];
        return YES;
    }];
    
    [self.app tap];

    XCTAssertTrue([self.app isDisplayingLocationPermission]);

    [[self.app locationAllowButton] tap];

    [self addUIInterruptionMonitorWithDescription:@"location" handler:^BOOL(XCUIElement * _Nonnull interruptingElement) {
        [[[interruptingElement buttons] objectForKeyedSubscript:@"Allow"] tap];
        return YES;
    }];
    
    [self.app tap];
}

@end
