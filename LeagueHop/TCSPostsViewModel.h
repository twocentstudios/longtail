//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewModel.h"

@class TCSPostController, TCSInformationViewModel;

// Loads an array of postViewModels.
// Presents settings if triggered by user or import is out of date.
// Presents login if no imports necessary.
// Can push web sites.
@interface TCSPostsViewModel : TCSViewModel

@property (nonatomic, readonly) NSString *title;

@property (nonatomic, readonly) NSArray *postViewModels; // TCSPostViewModels

// Initiates loading the posts for the day from the database. Does NOT initiate an import.
@property (nonatomic, readonly) RACCommand *loadPostsCommand;

// The empty view model that should be bound to the empty view.
@property (nonatomic, readonly) TCSInformationViewModel *emptyViewModel;

// Sends a TCSLoginViewModel.
@property (nonatomic, readonly) RACCommand *presentSettingsCommand;

// Sends a LogInViewModel if login/import should be presented.
@property (nonatomic, readonly) RACSignal *shouldPresentLogInSignal;

// Sends a TCSWebViewModel when executed with a NSURL as a parameter.
@property (nonatomic, readonly) RACCommand *openURLCommand;

- (instancetype)initWithController:(TCSPostController *)controller;

@end
