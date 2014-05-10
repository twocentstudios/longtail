//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSPostObject.h"

#import "TCSLikeObject.h"
#import "TCSCommentObject.h"

#pragma mark -

@implementation TCSPostObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"postId": @"id",
             @"userId": @"from.id",
             @"userName": @"from.name",
             @"type": @"type",
             @"message": @"message",
             @"pictureURL": @"picture",
             @"linkURL": @"link",
             @"linkName": @"name",
             @"iconURL": @"icon",
             @"sourceURL": @"source",
             @"caption": @"caption",
             @"description": @"description",
             @"createdAt": @"created_time",
             @"updatedAt": @"updated_time",
             @"likes": @"likes",
             @"comments": @"comments",
             };
}

+ (NSValueTransformer *)pictureURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)linkURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)iconURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)sourceURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *rawDateString) {
        return [[self dateFormatter] dateFromString:rawDateString];
    } reverseBlock:^(NSDate *date) {
        return [[self dateFormatter] stringFromDate:date];
    }];
}

+ (NSValueTransformer *)updatedAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *rawDateString) {
        return [[self dateFormatter] dateFromString:rawDateString];
    } reverseBlock:^(NSDate *date) {
        return [[self dateFormatter] stringFromDate:date];
    }];
}

+ (NSValueTransformer *)likesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[TCSLikeObject class]];
}

+ (NSValueTransformer *)commentsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[TCSCommentObject class]];
}

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
    });
    return formatter;
}

@end
