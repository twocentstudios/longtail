//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

// Creates a somewhat randomized color based on an input number.
// The color is derived from the number. The output color will always be the same for a given number.
// There are 360 different possible colors.
@interface UIColor (TCSColorId)

// Converts a Facebook userId to a long long integer before calling brightColorForNumber.
+ (UIColor *)brightColorForFacebookUserId:(NSString *)userId;

// Converts a long long unsigned integer into a hue value in the HSB color space.
// Saturation and Brightness are locked at a "happy" and "bright" setting.
+ (UIColor *)brightColorForNumber:(NSNumber *)number;

@end
