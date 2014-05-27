//
//  TCSWebViewController.h
//  LeagueHop
//
//  Created by Chris Trott on 5/27/14.
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewController.h"

#import "TCSWebViewModel.h"

@interface TCSWebViewController : TCSViewController

@property (nonatomic, readonly) TCSWebViewModel *viewModel;

@end
