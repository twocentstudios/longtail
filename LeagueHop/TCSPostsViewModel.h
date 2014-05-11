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

@property (nonatomic, readonly) RACCommand *loadPostsCommand;

- (instancetype)initWithController:(TCSPostController *)controller;

@end
