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

/// Current contacts authorization status
+ (CNAuthorizationStatus)currentStatus;

/// Display system popup to ask for permission
+ (void)askContactsPermission:(void (^)(CNAuthorizationStatus status))completion;

/// Fetch contacts that have at least one postal address in their address book
+ (NSArray<CNContact *> *__nullable)fetchContactWithAddress;

/// Store contacts for the given managedObjectContext. For each contact, we will try
/// to geocode their postal address so we can retrieve their weather later.
+ (void)store:(NSArray<CNContact *> *__nullable)contacts with:(NSManagedObjectContext *__nonnull)managedObjectContext;

@end

NS_ASSUME_NONNULL_END
