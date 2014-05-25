//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewModel.h"

@class TCSPostObject;

#pragma mark -

@interface TCSPostViewModel : TCSViewModel

@property (nonatomic, readonly) NSString *groupName;
@property (nonatomic, readonly) NSString *userName;
@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) NSString *createdAt;
@property (nonatomic, readonly) NSString *likesSummary;
@property (nonatomic, readonly) NSAttributedString *commentsSummary;

- (instancetype)initWithPost:(TCSPostObject *)post;

@end
