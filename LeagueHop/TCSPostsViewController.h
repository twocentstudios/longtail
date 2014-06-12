//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewController.h"

#import "TCSPostsViewModel.h"

// Shows posts provided by a postViewModel.
// Can present a login or settings flow.
// Can push web view controllers.
@interface TCSPostsViewController : TCSViewController

@property (nonatomic, readonly) TCSPostsViewModel *viewModel;

@end
