//
//  ContactPermissionPresenter.h
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactPermissionProtocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContactPermissionPresenter : NSObject <ContactPermissionViewToPresenter, ContactPermissionInteractorToPresenter>

- (instancetype)initWithView:(id<ContactPermissionPresenterToView> _Nullable)view
                  interactor:(id<ContactPermissionPresenterToInteractor> _Nullable)interactor
                      router:(id<ContactPermissionPresenterToRouter> _Nullable)router;

@end

NS_ASSUME_NONNULL_END
