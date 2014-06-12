//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

// Additional date key attributes to aid in querying.
@interface NSDate (TCSDateKey)

// 0411
- (NSString *)monthDayDateKey;

// 20120411
- (NSString *)yearMonthDayDateKey;

@end
