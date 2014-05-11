//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "NSDate+TCSDateKey.h"


#pragma mark -

@implementation NSDate (TCSDateKey)

- (NSString *)monthDayDateKey {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    return [NSString stringWithFormat:@"%@%@", @(components.month), @(components.day)];
}

- (NSString *)yearMonthDayDateKey {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    return [NSString stringWithFormat:@"%@%@%@", @(components.year), @(components.month), @(components.day)];
}

@end
