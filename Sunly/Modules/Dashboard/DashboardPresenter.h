//
//  DashboardPresenter.h
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DashboardProtocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface DashboardPresenter : NSObject <DashboardViewToPresenter, DashboardInteractorToPresenter>

- (instancetype)initWithView:(id<DashboardPresenterToView> _Nullable)view
                  interactor:(id<DashboardPresenterToInteractor> _Nullable)interactor
                      router:(id<DashboardPresenterToRouter> _Nullable)router;

@end

NS_ASSUME_NONNULL_END
