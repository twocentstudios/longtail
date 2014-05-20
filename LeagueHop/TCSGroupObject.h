//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import <Mantle/Mantle.h>

#pragma mark -

@interface TCSGroupObject : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *groupId;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSNumber *order;

@end
