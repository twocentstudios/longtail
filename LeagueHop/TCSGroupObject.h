//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import <Mantle/Mantle.h>

#import "TCSSourceObject.h"

@interface TCSGroupObject : MTLModel <MTLJSONSerializing, TCSSourceObject>

@property (nonatomic, copy, readonly) NSString *groupId;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSNumber *order;

@end
