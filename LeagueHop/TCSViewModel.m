//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewModel.h"

#import "TCSViewModel+Protected.h"

#pragma mark -

@implementation TCSViewModel

- (id)init {
	self = [super init];
	if (self == nil) return nil;

	_errors = [[RACSubject subject] setNameWithFormat:@"%@ -errors", self];

	return self;
}

- (void)dealloc {
	[_errors sendCompleted];
}

@end
