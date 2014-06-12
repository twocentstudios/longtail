//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSGroupViewModel.h"
#import "TCSViewModel+Protected.h"

#import "TCSGroupObject.h"

@interface TCSGroupViewModel ()

@property (nonatomic) TCSGroupObject *group;

@property (nonatomic) NSString *name;

@end

#pragma mark -

@implementation TCSGroupViewModel

- (instancetype)initWithGroup:(TCSGroupObject *)group {
    self = [super init];
    if (self != nil) {
        _group = group;

        RAC(self, name) = RACObserve(self.group, name);
        _selected = NO;
    }
    return self;
}

@end
