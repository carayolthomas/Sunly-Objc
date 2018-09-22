//
//  ContactPermissionPresenter.m
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "ContactPermissionPresenter.h"
#import "UIColor+Additions.h"
#import "CNContact+Filter.h"
#import "ContactHelper.h"
#import "AppDelegate.h"

#import <Contacts/Contacts.h>
#import <CoreData/CoreData.h>

@interface ContactPermissionPresenter ()

@property (strong, nonatomic, readonly) NSPersistentContainer *persistentContainer;

@end

@implementation ContactPermissionPresenter

@synthesize interactor;
@synthesize router;
@synthesize view;

- (instancetype)initWithView:(id<ContactPermissionPresenterToView> __nullable)view
                  interactor:(id<ContactPermissionPresenterToInteractor> __nullable)interactor
                      router:(id<ContactPermissionPresenterToRouter> __nullable)router {
    
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        self.router = router;
    }
    return self;
}

#pragma mark - ContactPermissionViewToPresenter

- (void)nextButtonTapped {
    [ContactHelper askContactsPermission:^(CNAuthorizationStatus status) {
        [self handeContactAuthorizationStatus:status];
    }];
}

- (void)viewDidLoad {
    [[self view] configureBackgroundColor:[UIColor skyBlueColor]];
    [[self view] showContactImageView:[UIImage imageNamed:@"contact"]];
    [[self view] showWelcomeMessage:NSLocalizedStringFromTable(@"ContactPermissionWelcome", @"OnBoarding", @"")];
    [[self view] showContactMessage:NSLocalizedStringFromTable(@"ContactPermissionInfo", @"OnBoarding", @"")];
    [[self view] configureNextButton:NSLocalizedStringFromTable(@"ContactPermissionAction", @"OnBoarding", @"")];
}

- (void)viewDidAppear {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self handeContactAuthorizationStatus:[ContactHelper currentStatus]];
    }];
}

- (void)handeContactAuthorizationStatus:(CNAuthorizationStatus)status {
    if (status == CNAuthorizationStatusAuthorized) {
        [self contactAuthorizedBehavior];
    } else if (status == CNAuthorizationStatusRestricted) {
        [self contactRestrictedBehavior];
    } else if (status == CNAuthorizationStatusDenied) {
        [self contactDeniedBehavior];
    }
}

- (void)contactAuthorizedBehavior {
    NSArray<CNContact *> *contacts = [ContactHelper fetchContactWithAddress];
    NSManagedObjectContext *managedObjectContext = [[AppDelegate persistentContainer] viewContext];
    [ContactHelper store:contacts with:managedObjectContext];
}

- (void)contactRestrictedBehavior {
    [[self view] showAlertWith:NSLocalizedStringFromTable(@"ContactPermissionRestrictedTitle", @"OnBoarding", @"") and:NSLocalizedStringFromTable(@"ContactPermissionRestrictedMessage", @"OnBoarding", @"")];
}

- (void)contactDeniedBehavior {
    [[self view] showSettingsAlertWith:NSLocalizedStringFromTable(@"ContactPermissionDeniedTitle", @"OnBoarding", @"") and:NSLocalizedStringFromTable(@"ContactPermissionDeniedMessage", @"OnBoarding", @"")];
}

- (void)dealloc {
    NSLog(@"dealloc");
}

@end
