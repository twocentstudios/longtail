//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSPostObject.h"

#import "TCSUserObject.h"
#import "TCSCommentObject.h"

#pragma mark -

@implementation TCSPostObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"postId": @"id",
             @"user": @"from",
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
             @"monthDayKey": @"created_time",
             @"yearMonthDayKey": @"created_time",
             @"likes": @"likes.data",
             @"comments": @"comments.data",
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

+ (NSValueTransformer *)monthDayKeyJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSString *rawDateString) {
        NSDate *date = [[self dateFormatter] dateFromString:rawDateString];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
        return [NSString stringWithFormat:@"%@%@", @(components.month), @(components.day)];
    }];
}

+ (NSValueTransformer *)yearMonthDayKeyJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSString *rawDateString) {
        NSDate *date = [[self dateFormatter] dateFromString:rawDateString];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
        return [NSString stringWithFormat:@"%@%@%@", @(components.year), @(components.month), @(components.day)];
    }];
}

+ (NSValueTransformer *)userJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[TCSUserObject class]];
}

+ (NSValueTransformer *)likesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[TCSUserObject class]];
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
