//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import <Mantle/Mantle.h>

#import "TCSSourceObject.h"

@class TCSUserObject;

#pragma mark -

@interface TCSPostObject : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *postId;
@property (nonatomic, copy, readonly) TCSUserObject *user;
@property (nonatomic, copy, readonly) NSString *type; // video, status, link, photo
@property (nonatomic, copy, readonly) NSString *message; // the primary text entered by the user.
@property (nonatomic, copy, readonly) NSURL *pictureURL; // the image preview for a photo, link, or video
@property (nonatomic, copy, readonly) NSURL *linkURL; // the location of the photo, link, or video
@property (nonatomic, copy, readonly) NSString *linkName; // the service's provided title text of a link
@property (nonatomic, copy, readonly) NSURL *iconURL; // a tiny image representing the post type
@property (nonatomic, copy, readonly) NSURL *sourceURL; 
@property (nonatomic, copy, readonly) NSString *caption; // the service's provided subtitle text of a link
@property (nonatomic, copy, readonly) NSString *content;
@property (nonatomic, copy, readonly) NSDate *createdAt;
@property (nonatomic, copy, readonly) NSDate *updatedAt;
@property (nonatomic, copy, readonly) NSString *monthDayKey; // 0411
@property (nonatomic, copy, readonly) NSString *yearMonthDayKey; // 20120411
@property (nonatomic, copy, readonly) NSArray *likes; // TCSUserObject
@property (nonatomic, copy, readonly) NSArray *comments; // TCSCommentObject
@property (nonatomic, copy, readonly) id<TCSSourceObject> sourceObject; // The source of a post, i.e. the "wall" that the post was posted to

@end
