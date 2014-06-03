//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewModel.h"

@class TCSPostObject;

#pragma mark -

@interface TCSPostViewModel : TCSViewModel

@property (nonatomic, readonly) NSAttributedString *userName;
@property (nonatomic, readonly) NSAttributedString *postSummary;
@property (nonatomic, readonly) NSAttributedString *year;
@property (nonatomic, readonly) NSAttributedString *message;
@property (nonatomic, readonly) NSAttributedString *likesSummary;
@property (nonatomic, readonly) NSAttributedString *commentsSummary;

@property (nonatomic, readonly) RACCommand *openURLCommand;

// The view model's owner can cache view height calculations here.
@property (nonatomic) NSNumber *cachedViewHeight;

- (instancetype)initWithPost:(TCSPostObject *)post openURLCommand:(RACCommand *)openURLCommand;

@end
