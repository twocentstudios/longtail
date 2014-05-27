//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewController.h"

#import "TCSViewModel.h"

#pragma mark -

@interface TCSViewController ()

@end


@implementation TCSViewController

#pragma mark UIViewController

- (instancetype)initWithViewModel:(TCSViewModel *)viewModel {
	self = [super initWithNibName:nil bundle:nil];
	if (self == nil) return nil;

	_viewModel = viewModel;

	RACSignal *presented =
        [[RACSignal
            merge:@[
                    [[self rac_signalForSelector:@selector(viewDidAppear:)] mapReplace:@YES],
                    [[self rac_signalForSelector:@selector(viewWillDisappear:)] mapReplace:@NO]
                    ]]
            setNameWithFormat:@"%@ presented", self];

	RACSignal *appActive =
        [[[RACSignal
            merge:@[
                    [[NSNotificationCenter.defaultCenter rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] mapReplace:@YES],
                    [[NSNotificationCenter.defaultCenter rac_addObserverForName:UIApplicationWillResignActiveNotification object:nil] mapReplace:@NO]
                    ]]
            startWith:@YES]
            setNameWithFormat:@"%@ appActive", self];

	RAC(self, viewModel.active) =
        [[[RACSignal
            combineLatest:@[ presented, appActive ]]
            and]
            setNameWithFormat:@"%@ active", self];

	[self rac_liftSelector:@selector(presentError:) withSignals:self.viewModel.errors, nil];
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	UIView *overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
	overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	overlayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
	[self.view addSubview:overlayView];

	UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[loadingView startAnimating];
	[overlayView addSubview:loadingView];

	RCLFrame(loadingView) = @{
                              rcl_center: overlayView.rcl_boundsSignal.center
                              };

	RAC(overlayView, alpha) =
        [[[[RACObserve(self, loading)
            distinctUntilChanged]
            map:^(NSNumber *loading) {
                return loading.boolValue ? @1 : @0;
            }]
            animateWithDuration:0.25 curve:RCLAnimationCurveLinear]
            startWith:@0];
}

#pragma mark Error handling

- (void)presentError:(NSError *)error {
	NSLog(@"%@", error);
    
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
	[alertView show];
}


@end
