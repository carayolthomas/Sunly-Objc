//
//  DashboardViewController.h
//  Sunly
//
//  Created by Thomas Carayol on 21/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardProtocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface DashboardViewController : UIViewController <DashboardPresenterToView>

@property (nonatomic, nullable) id<DashboardViewToPresenter> presenter;

@end

NS_ASSUME_NONNULL_END
