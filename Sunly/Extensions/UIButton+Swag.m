//
//  UIButton+Swag.m
//  Sunly
//
//  Created by Thomas Carayol on 22/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "UIButton+Swag.h"
#import "UIColor+Additions.h"

@implementation UIButton (Swag)

- (void)nextStepWithTitle:(NSString *)title {
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:[UIColor skyBlueColor] forState:UIControlStateNormal];
    [[self layer] setMasksToBounds:YES];
    [[self layer] setCornerRadius:5.f];
}

@end
