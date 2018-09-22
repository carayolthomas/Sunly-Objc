//
//  LocationPermissionViewController.h
//  Sunly
//
//  Created by Thomas Carayol on 21/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationPermissionProtocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocationPermissionViewController : UIViewController <LocationPermissionPresenterToView>

@property (nonatomic, nullable) id<LocationPermissionViewToPresenter> presenter;

@end

NS_ASSUME_NONNULL_END
