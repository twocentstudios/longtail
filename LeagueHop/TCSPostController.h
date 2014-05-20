//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#pragma mark -

@interface TCSPostController : NSObject

// Sends an array of posts that happened on that day in all years in history then completes.
// dateKey is a 4 character code in the format MMDD.
// Note: this signal performs all work on a background thread.
- (RACSignal *)fetchPostsForMonthDayKey:(NSString *)monthDayKey;

// Sends complete when all posts have been imported.
// sourceID is the ID of the group whose feed will be imported.
// Note: this signal performs all work on a background thread.
- (RACSignal *)importPostsForSourceID:(NSString *)sourceID;

@end
