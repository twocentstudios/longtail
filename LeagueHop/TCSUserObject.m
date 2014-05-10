//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSUserObject.h"


#pragma mark -

@implementation TCSUserObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userId": @"id",
             @"userName": @"name",
             };
}

@end
