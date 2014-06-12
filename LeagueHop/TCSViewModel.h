//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

// The base view model for all other view models.
@interface TCSViewModel : RVMViewModel

// A unified signal of all errors that have occurred within the view model.
@property (nonatomic, strong, readonly) RACSignal *errors;

@end
