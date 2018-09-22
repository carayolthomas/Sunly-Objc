//
//  ContactPermissionInteractor.m
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "ContactPermissionInteractor.h"
#import "ContactHelper.h"
#import "AppDelegate.h"

#import <Contacts/Contacts.h>

@implementation ContactPermissionInteractor

@synthesize presenter;

- (void)storeContacts:(NSArray<CNContact *> *)contacts {
    NSManagedObjectContext *managedObjectContext = [[AppDelegate persistentContainer] viewContext];
    [ContactHelper store:contacts with:managedObjectContext];
}

@end
