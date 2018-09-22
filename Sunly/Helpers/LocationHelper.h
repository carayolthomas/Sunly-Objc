//
//  LocationHelper.h
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

NS_ASSUME_NONNULL_BEGIN

typedef void(^LocationCompletion)(CLLocation *__nullable location, CLAuthorizationStatus status);

@interface LocationHelper : NSObject

+ (CLAuthorizationStatus)currentStatus;
- (void)askLocationPermission:(LocationCompletion)completion;

@end

NS_ASSUME_NONNULL_END