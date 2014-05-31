//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewModel.h"

@class TCSPostController;

#pragma mark -

@interface TCSPostsViewModel : TCSViewModel

@property (nonatomic, readonly) NSString *title;

@property (nonatomic, readonly) NSArray *postViewModels; // TCSPostViewModels

// Initiates loading the posts for the day from the database. Does NOT initiate an import.
@property (nonatomic, readonly) RACCommand *loadPostsCommand;

// Sends a TCSLoginViewModel.
@property (nonatomic, readonly) RACCommand *presentSettingsCommand;

// Triggers `presentSettingsCommand` if login/import should be presented.
@property (nonatomic, readonly) RACSignal *shouldPresentSettingsSignal;

// Sends a TCSWebViewModel when executed with a NSURL as a parameter.
@property (nonatomic, readonly) RACCommand *openURLCommand;

- (instancetype)initWithController:(TCSPostController *)controller;

@end
