//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewModel.h"

@class TCSPostController;

@interface TCSGroupImportViewModel : TCSViewModel

@property (nonatomic, readonly) NSString *title;

// The groups to be imported.
@property (nonatomic, readonly) NSArray *groups; // TCSGroupObject

// Importing is automatically initialized when the parent view controller becomes active.
@property (nonatomic, readonly) RACCommand *importCommand;

// Sends the number of posts imported as an NSString each time a group finishes
// importing then completes.
@property (nonatomic, readonly) RACSignal *importedPostsCountsSignal;

- (instancetype)initWithGroup:(NSArray *)groups controller:(TCSPostController *)controller;

@end
