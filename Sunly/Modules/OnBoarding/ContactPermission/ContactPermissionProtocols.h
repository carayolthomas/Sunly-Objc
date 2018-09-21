//
//  ContactPermissionProtocols.h
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ContactPermissionInteractorToPresenter <NSObject>



@end

@protocol ContactPermissionPresenterToView <NSObject>


@end

@protocol ContactPermissionPresenterToInteractor <NSObject>

@required
@property (nullable) id<ContactPermissionInteractorToPresenter> presenter;


@end

@protocol ContactPermissionPresenterToRouter <NSObject>

@required
+ (UIViewController* _Nullable)createModule;

@end

@protocol ContactPermissionViewToPresenter <NSObject>

@required
@property (nonatomic, weak, nullable) id<ContactPermissionPresenterToView> view;
@property (nonatomic, nullable) id<ContactPermissionPresenterToInteractor> interactor;
@property (nonatomic, nullable) id<ContactPermissionPresenterToRouter> router;

@end

NS_ASSUME_NONNULL_END
