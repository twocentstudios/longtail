//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface TCSUserObject : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *userId;
@property (nonatomic, copy, readonly) NSString *userName;

@end
