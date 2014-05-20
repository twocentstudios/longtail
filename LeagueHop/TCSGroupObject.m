//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSGroupObject.h"


#pragma mark -

@implementation TCSGroupObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"groupId": @"id",
             @"name": @"name",
             @"order": @"bookmark_order",
             };
}

@end
