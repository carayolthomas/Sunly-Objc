//
//  ContactPermissionViewController.h
//  Sunly
//
//  Created by Thomas Carayol on 21/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactPermissionProtocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContactPermissionViewController : UIViewController <ContactPermissionPresenterToView>

@property (nonatomic, nullable) id<ContactPermissionViewToPresenter> presenter;

@end

NS_ASSUME_NONNULL_END
