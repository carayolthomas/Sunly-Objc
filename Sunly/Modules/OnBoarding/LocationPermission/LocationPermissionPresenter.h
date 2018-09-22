//
//  LocationPermissionPresenter.h
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationPermissionProtocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocationPermissionPresenter : NSObject <LocationPermissionViewToPresenter, LocationPermissionInteractorToPresenter>

- (instancetype)initWithView:(id<LocationPermissionPresenterToView> _Nullable)view
                  interactor:(id<LocationPermissionPresenterToInteractor> _Nullable)interactor
                      router:(id<LocationPermissionPresenterToRouter> _Nullable)router;

@end

NS_ASSUME_NONNULL_END
