//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

@class TCSViewModel;

// A base view controller with a few basic functions:
// * Pins a loading view to the top of its view and shows it when loading == YES.
// * Presents errors in UIAlertViews.
@interface TCSViewController : UIViewController

@property (nonatomic, strong, readonly) TCSViewModel *viewModel;

@property (nonatomic, getter = isLoading) BOOL loading;

- (id)initWithViewModel:(TCSViewModel *)viewModel;

- (void)presentError:(NSError *)error;

@end
