//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewModel.h"

#pragma mark -

@interface TCSInformationViewModel : TCSViewModel

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *subtitle;

@property (nonatomic, getter = isHidden) BOOL hidden;

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle;

@end
