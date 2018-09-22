//
//  ContactHelper.h
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Contacts;
@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface ContactHelper : NSObject

+ (CNAuthorizationStatus)currentStatus;
+ (void)askContactsPermission:(void (^)(CNAuthorizationStatus status))completion;
+ (NSArray<CNContact *> *__nullable)fetchContactWithAddress;
+ (void)store:(NSArray<CNContact *> *__nullable)contacts with:(NSManagedObjectContext *__nonnull)managedObjectContext;

@end

NS_ASSUME_NONNULL_END
