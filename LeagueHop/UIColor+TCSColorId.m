//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "UIColor+TCSColorId.h"


#pragma mark -

@implementation UIColor (TCSColorId)

+ (UIColor *)brightColorForNumber:(NSNumber *)number {
    NSNumber *hueNumber = number ?: @0;
    NSUInteger hue = [hueNumber unsignedIntegerValue] % 360;
    CGFloat hueFloat = hue/360.0f;
    return [UIColor colorWithHue:hueFloat saturation:0.5 brightness:0.8 alpha:1];
}

@end
