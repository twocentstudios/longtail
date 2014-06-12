//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewModel.h"

// Provides basic information about a view state (e.g. empty state, error state).
// Should be controlled by another view model.
@interface TCSInformationViewModel : TCSViewModel

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *subtitle;

@property (nonatomic, getter = isHidden) BOOL hidden;

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle;

@end
