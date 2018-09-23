//
//  WeatherCollectionViewCell.h
//  Sunly
//
//  Created by Thomas Carayol on 23/09/2018.
//  Copyright © 2018 Thomas Carayol. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherCollectionViewCell : UICollectionViewCell

- (void)reload:(UIImage *)backgroundImage topText:(NSString *)topText midText:(NSAttributedString *)midText bottomText:(NSString *)bottomText shadowColor:(UIColor *)shadowColor;

@end

NS_ASSUME_NONNULL_END
