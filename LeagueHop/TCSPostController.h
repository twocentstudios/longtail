//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

// Handles the following functions:
// * Importing posts from Facebook Groups.
// * Keeping track of the last time posts were imported.
// * Querying posts by date key.
// * Getting a list of Facebook Groups.
// * Truncating the database.
@interface TCSPostController : NSObject

// Sends an array of posts that happened on that day in all years in history then completes.
// dateKey is a 4 character code in the format MMDD.
// Note: posts should already have been imported, otherwise this will always return empty results.
- (RACSignal *)queryPostsForMonthDayKey:(NSString *)monthDayKey;

// Sends an NSNumber-wrapped BOOL for whether an import is required then completes.
- (RACSignal *)isImportNeeded;

// Marks that last imported date, sends that date, and completes.
// Pass a nil importedDate to clear the date and (presumably) trigger an import on next check.
- (RACSignal *)markImportedDate:(NSDate *)importedDate;

// Requests a list of the current user's Facebook groups.
// Sends an array of `TCSGroupObject`s then completes.
// Note: requires an active Facebook session.
- (RACSignal *)getGroups;

// Recursively fetchs all the posts of the groups passed as an argument from Facebook,
// sends an NSNumber-wrapped NSInteger of the number of posts imported for each group (zero or more `next`s),
// writes the posts to the database, marks the imported date as now, then completes.
// Note: this can take a long time depending on how many groups the user has and the number of posts each group has.
// Note: requires an active Facebook session. (TODO: make this dependency explicit).
- (RACSignal *)importPostsForGroups:(NSArray *)groups;

// Truncates all posts from the database, removes the last imported date, and completes.
- (RACSignal *)removeAllObjects;

@end
