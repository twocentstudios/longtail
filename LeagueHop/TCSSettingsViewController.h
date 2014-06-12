//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewController.h"

#import "TCSSettingsViewModel.h"

// A manually laid out scroll view with buttons.
// Can push other view controllers onto its navigation controller.
@interface TCSSettingsViewController : TCSViewController

@property (nonatomic, readonly) TCSSettingsViewModel *viewModel;

@end
