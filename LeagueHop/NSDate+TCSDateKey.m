//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "NSDate+TCSDateKey.h"


#pragma mark -

@implementation NSDate (TCSDateKey)

- (NSString *)monthDayDateKey {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    NSString *string = [NSString stringWithFormat:@"%02li%02li", (long)components.month, (long)components.day];
    return string;
}

- (NSString *)yearMonthDayDateKey {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    NSString *string = [NSString stringWithFormat:@"%04li%02li%02li", (long)components.year, (long)components.month, (long)components.day];
    return string;
}

@end
