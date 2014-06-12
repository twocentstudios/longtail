//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewController.h"

#import "TCSTopBarActivityView.h"

#import "TCSViewModel.h"

@interface TCSViewController ()

@property (nonatomic) TCSTopBarActivityView *activityView;

@end

#pragma mark -

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

    self.activityView = [[TCSTopBarActivityView alloc] init];
    [self.view addSubview:self.activityView];

    RAC(self.activityView, loading) = RACObserve(self, loading);

    [self.activityView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
}

#pragma mark Error handling

- (void)presentError:(NSError *)error {
	NSLog(@"%@", error);
    
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
	[alertView show];
}


@end
