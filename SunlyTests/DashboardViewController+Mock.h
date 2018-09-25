//
//  DashboardViewController+Mock.h
//  SunlyTests
//
//  Created by Thomas Carayol on 25/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DashboardProtocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface MockDashboardViewController : UIViewController <DashboardPresenterToView>

@property (nonatomic, nullable) id<DashboardViewToPresenter> presenter;

@end

NS_ASSUME_NONNULL_END
