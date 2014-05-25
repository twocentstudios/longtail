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

#pragma mark TCSSourceObject

- (NSString *)sourceId {
    return self.groupId;
}

- (NSString *)sourceName {
    return self.name;
}

@end
