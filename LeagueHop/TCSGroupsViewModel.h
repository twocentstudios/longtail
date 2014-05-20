//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewModel.h"

@class TCSPostController;

#pragma mark -

@interface TCSGroupsViewModel : TCSViewModel

@property (nonatomic, readonly) NSString *title;

@property (nonatomic, readonly) NSArray *groupViewModels; // TCSGroupViewModels

@property (nonatomic, readonly) RACCommand *loadGroupsCommand;

- (instancetype)initWithController:(TCSPostController *)controller;

@end
