//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -

@interface UIColor (TCSColorId)

// Converts a Facebook userId to a long long integer before calling brightColorForNumber.
+ (UIColor *)brightColorForFacebookUserId:(NSString *)userId;

// Converts a long long unsigned integer into a hue value in the HSB color space.
// Saturation and Brightness are locked at a "happy" and "bright" setting.
+ (UIColor *)brightColorForNumber:(NSNumber *)number;

@end
