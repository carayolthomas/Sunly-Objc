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

#import <Contacts/Contacts.h>

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

#pragma mark - Contacts



#pragma mark - ContactPermissionViewToPresenter

- (void)nextButtonTapped {
    // TODO:
}

- (void)viewDidLoad {
    [[self view] configureBackgroundColor:[UIColor skyBlueColor]];
    [[self view] showContactImageView:[UIImage imageNamed:@"contact"]];
    [[self view] showWelcomeMessage:NSLocalizedStringFromTable(@"ContactPermissionWelcome", @"OnBoarding", @"")];
    [[self view] showContactMessage:NSLocalizedStringFromTable(@"ContactPermissionInfo", @"OnBoarding", @"")];
    [[self view] configureNextButton:NSLocalizedStringFromTable(@"ContactPermissionAction", @"OnBoarding", @"")];
}

@end
