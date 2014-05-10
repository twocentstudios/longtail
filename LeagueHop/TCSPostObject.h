//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import <Mantle/Mantle.h>

@class TCSUserObject;

#pragma mark -

@interface TCSPostObject : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *postId;
@property (nonatomic, copy, readonly) TCSUserObject *user;
@property (nonatomic, copy, readonly) NSString *type; // video, status, link, photo
@property (nonatomic, copy, readonly) NSString *message;
@property (nonatomic, copy, readonly) NSURL *pictureURL;
@property (nonatomic, copy, readonly) NSURL *linkURL;
@property (nonatomic, copy, readonly) NSString *linkName;
@property (nonatomic, copy, readonly) NSURL *iconURL;
@property (nonatomic, copy, readonly) NSURL *sourceURL;
@property (nonatomic, copy, readonly) NSString *caption;
@property (nonatomic, copy, readonly) NSString *description;
@property (nonatomic, copy, readonly) NSDate *createdAt;
@property (nonatomic, copy, readonly) NSDate *updatedAt;
@property (nonatomic, copy, readonly) NSString *monthDayKey; // 0411
@property (nonatomic, copy, readonly) NSString *yearMonthDayKey; // 20120411
@property (nonatomic, copy, readonly) NSArray *likes; // TCSUserObject
@property (nonatomic, copy, readonly) NSArray *comments; // TCSCommentObject

@end
