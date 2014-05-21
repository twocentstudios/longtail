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

// Sends a TCSGroupImportViewModel if group import should be presented.
@property (nonatomic, readonly) RACSignal *presentGroupImportSignal;

- (instancetype)initWithController:(TCSPostController *)controller;

@end
