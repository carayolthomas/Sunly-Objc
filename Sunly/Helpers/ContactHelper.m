//
//  ContactHelper.m
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "ContactHelper.h"
#import "SunlyContact.h"
#import "CNContact+Filter.h"

@implementation ContactHelper

+ (void)askContactsPermission:(void (^)(CNAuthorizationStatus status))completion {
    CNEntityType entityType = CNEntityTypeContacts;
    if ([CNContactStore authorizationStatusForEntityType:entityType] == CNAuthorizationStatusNotDetermined) {
        CNContactStore * contactStore = [[CNContactStore alloc] init];
        [contactStore requestAccessForEntityType:entityType completionHandler:^(BOOL granted, NSError * __nullable error) {
            if (granted) {
                completion(CNAuthorizationStatusAuthorized);
            } else {
                completion(CNAuthorizationStatusDenied);
            }
        }];
    } else {
        completion([CNContactStore authorizationStatusForEntityType:entityType]);
    }
}

+ (NSArray<CNContact *> *__nullable)fetchContactWithAddress {
    NSMutableArray<CNContact *> *contacts = [NSMutableArray new];
    NSError *contactError;
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore containersMatchingPredicate:[CNContainer predicateForContainersWithIdentifiers: @[contactStore.defaultContainerIdentifier]] error:&contactError];
    NSArray * keysToFetch =@[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPostalAddressesKey, CNContactImageDataAvailableKey, CNContactImageDataKey, CNContactThumbnailImageDataKey];
    
    NSArray *containers = [contactStore containersMatchingPredicate:nil error:&contactError];
    
    if (contactError) {
        return nil;
    }
    
    for (CNContainer *container in containers) {
        NSPredicate *fetchPredicate = [CNContact predicateForContactsInContainerWithIdentifier:container.identifier];
        NSArray<CNContact*> *result = [contactStore unifiedContactsMatchingPredicate:fetchPredicate keysToFetch:keysToFetch error:&contactError];
        if (!contactError) {
            [contacts addObjectsFromArray:result];
        }
    }
    
    NSPredicate *postalAddressPredicate = [NSPredicate predicateWithBlock:^BOOL(CNContact  *__nullable evaluatedObject, NSDictionary<NSString *,id> * __nullable bindings) {
        return evaluatedObject.hasPostalAddresses;
    }];
    
    [contacts filterUsingPredicate:postalAddressPredicate];
    
    return contacts;
}

+ (NSArray<SunlyContact *> *__nonnull)transform:(NSArray<CNContact *> *__nullable)contacts {
    // TODO:
    return nil;
}

@end
