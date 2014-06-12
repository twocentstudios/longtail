//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewModel.h"

@class TCSPostController, TCSInformationViewModel;

// Loads a list of groupViewModels.
@interface TCSGroupsViewModel : TCSViewModel

@property (nonatomic, readonly) NSString *title;

@property (nonatomic, readonly) NSArray *groupViewModels; // TCSGroupViewModels

@property (nonatomic, readonly) RACCommand *loadGroupsCommand;
@property (nonatomic, readonly) RACCommand *confirmSelectionCommand;
@property (nonatomic, readonly) TCSInformationViewModel *emptyViewModel;

- (instancetype)initWithController:(TCSPostController *)controller;

@end
