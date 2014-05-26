//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "UIColor+TCSColorId.h"


#pragma mark -

@implementation UIColor (TCSColorId)

+ (UIColor *)brightColorForFacebookUserId:(NSString *)userId {
    return [self brightColorForNumber:@([userId longLongValue])];
}

+ (UIColor *)brightColorForNumber:(NSNumber *)number {
    NSNumber *hueNumber = number ?: @0;
    unsigned long long hue = [hueNumber unsignedLongLongValue] % 360;
    CGFloat hueFloat = hue/360.0f;
    return [UIColor colorWithHue:hueFloat saturation:0.5 brightness:0.75 alpha:1];
}

@end
