//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

// A generic "source" of data that only requires a unique Id and a name.
@protocol TCSSourceObject <NSObject>

- (NSString *)sourceId;
- (NSString *)sourceName;

@end
