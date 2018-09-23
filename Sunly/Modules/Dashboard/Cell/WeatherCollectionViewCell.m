//
//  WeatherCollectionViewCell.m
//  Sunly
//
//  Created by Thomas Carayol on 23/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import "WeatherCollectionViewCell.h"
#import "UIColor+Additions.h"

@interface WeatherCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (strong, nonatomic) IBOutlet UILabel *temperatureLocationLabel;
@property (strong, nonatomic) IBOutlet UILabel *hintLabel;
@property (strong, nonatomic) IBOutlet UILabel *purposeLabel;


@end

@implementation WeatherCollectionViewCell

- (void)reload:(UIImage *)backgroundImage topText:(NSString *)topText midText:(NSAttributedString *)midText bottomText:(NSString *)bottomText shadowColor:(UIColor *)shadowColor {
    
    self.weatherImageView.image = backgroundImage;
    self.purposeLabel.text = topText;
    self.temperatureLocationLabel.attributedText = midText;
    self.hintLabel.text = bottomText;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10.0];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    [shapeLayer setPath:[maskPath CGPath]];
    [[self.weatherImageView layer] setMask:shapeLayer];
    [[self layer] setMasksToBounds:NO];
    [[self layer] setShadowColor:[shadowColor CGColor]];
    [[self layer] setShadowRadius:10.0];
    [[self layer] setShadowOpacity:1.0];
    [[self layer] setShadowOffset:CGSizeMake(0, 5)];
}

@end
