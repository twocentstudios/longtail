//
//  TCSViewController.h
//  LeagueHop
//
//  Created by Chris Trott on 5/10/14.
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

@class TCSViewModel;

@interface TCSViewController : UIViewController

@property (nonatomic, strong, readonly) TCSViewModel *viewModel;

@property (nonatomic, getter = isLoading) BOOL loading;

- (id)initWithViewModel:(TCSViewModel *)viewModel;

- (void)presentError:(NSError *)error;

@end
