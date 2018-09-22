//
//  CNContact+Filter.h
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import <Contacts/Contacts.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNContact (Filter)

- (BOOL)hasPostalAddresses;
- (CNPostalAddress *__nullable)postalAddress;

@end

NS_ASSUME_NONNULL_END
