//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewModel.h"

@class TCSGroupObject;

#pragma mark -

@interface TCSGroupViewModel : TCSViewModel

@property (nonatomic, readonly) TCSGroupObject *group;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, getter = isSelected) BOOL selected;

- (instancetype)initWithGroup:(TCSGroupObject *)group;

@end
