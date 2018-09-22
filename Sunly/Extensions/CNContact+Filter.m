//
//  CNContact+Filter.m
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "CNContact+Filter.h"

@implementation CNContact (Filter)

- (BOOL)hasPostalAddresses {
    return self.postalAddress.city.length > 0 && self.postalAddress.country.length > 0;
}

- (CNPostalAddress *__nullable)postalAddress {
    return self.postalAddresses.firstObject.value;
}

@end
