//
//  ContactHelper.m
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "ContactHelper.h"
#import "CNContact+Filter.h"
#import "Contact+CoreDataProperties.h"
#import "Location+CoreDataProperties.h"
#import "Constants.h"

#import <CoreData/CoreData.h>
#import <Contacts/Contacts.h>
#import <CoreLocation/CoreLocation.h>

@implementation ContactHelper

+ (CNAuthorizationStatus)currentStatus {
    CNEntityType entityType = CNEntityTypeContacts;
    return [CNContactStore authorizationStatusForEntityType:entityType];
}

+ (void)askContactsPermission:(void (^)(CNAuthorizationStatus status))completion {
    CNEntityType entityType = CNEntityTypeContacts;
    if ([CNContactStore authorizationStatusForEntityType:entityType] == CNAuthorizationStatusNotDetermined) {
        CNContactStore * contactStore = [[CNContactStore alloc] init];
        [contactStore requestAccessForEntityType:entityType completionHandler:^(BOOL granted, NSError * __nullable error) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                completion(CNAuthorizationStatusAuthorized);
                });
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    completion(CNAuthorizationStatusDenied);
                });
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
    
    NSError *error;
    CNContactFetchRequest *meRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    [contactStore enumerateContactsWithFetchRequest:meRequest error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        // Quick trick here. The first is most certainly you. So I save this in defaults to remember you 🔥
        [[NSUserDefaults standardUserDefaults] setObject:contact.givenName forKey:UserGivenNameKey];
        // End of the trick.
        *stop = YES;
    }];
    
    return contacts;
}

+ (void)store:(NSArray<CNContact *> *__nullable)contacts with:(NSManagedObjectContext *__nonnull)managedObjectContext {
    
    NSError *error = nil;
    
    for (CNContact *contact in contacts) {
        
        NSFetchRequest *existingRequest = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
        [existingRequest setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", contact.identifier]];
        Contact *existingContact = [managedObjectContext executeFetchRequest:existingRequest error:&error].firstObject;
        
        if (existingContact) {
            existingContact.identifier = contact.identifier;
            existingContact.fullname = [NSString stringWithFormat:@"%@ %@", contact.givenName, contact.familyName];
            existingContact.thumbnail = contact.thumbnailImageData;
            existingContact.picture = contact.imageData;
            existingContact.location.city = contact.postalAddress.city;
            existingContact.location.country = contact.postalAddress.country;
            
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder geocodePostalAddress:contact.postalAddress completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                
                if (!error) {
                    existingContact.location.coordinate = [NSString stringWithFormat:@"%f,%f", placemarks.firstObject.location.coordinate.latitude, placemarks.firstObject.location.coordinate.longitude];
                }
                
                if ([managedObjectContext save:&error] == NO) {
                    NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                }
            }];
        } else {
            Contact *object = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:managedObjectContext];
            object.identifier = contact.identifier;
            object.fullname = [NSString stringWithFormat:@"%@ %@", contact.givenName, contact.familyName];
            object.thumbnail = contact.thumbnailImageData;
            object.picture = contact.imageData;
            object.location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:managedObjectContext];
            object.location.city = contact.postalAddress.city;
            object.location.country = contact.postalAddress.country;
            
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder geocodePostalAddress:contact.postalAddress completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                
                if (!error) {
                    object.location.coordinate = [NSString stringWithFormat:@"%f,%f", placemarks.firstObject.location.coordinate.latitude, placemarks.firstObject.location.coordinate.longitude];
                }
                
                if ([managedObjectContext save:&error] == NO) {
                    NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                }
            }];
        }
    }
    
    NSLog(@"SAVED!");
}

@end
