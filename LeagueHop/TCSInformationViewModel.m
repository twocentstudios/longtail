//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSInformationViewModel.h"

@interface TCSInformationViewModel ()

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;

@end

#pragma mark -

@implementation TCSInformationViewModel

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    self = [super init];
    if (self != nil) {
        _title = title;
        _subtitle = subtitle;
    }
    return self;
}

@end
