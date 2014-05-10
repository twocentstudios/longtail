//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import <Mantle/Mantle.h>

@class TCSUserObject;

#pragma mark -

@interface TCSCommentObject : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber *commentId;
@property (nonatomic, copy, readonly) TCSUserObject *user;
@property (nonatomic, copy, readonly) NSString *message;
@property (nonatomic, copy, readonly) NSDate *createdAt;
@property (nonatomic, copy, readonly) NSNumber *likeCount;

@end
