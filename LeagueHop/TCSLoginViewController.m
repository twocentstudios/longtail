//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSLoginViewController.h"

#import "TCSGroupSelectViewController.h"
#import "TCSGroupViewModel.h"

#pragma mark -

@interface TCSLoginViewController ()

@property (nonatomic) UIButton *logInOutButton;

@property (nonatomic) UIButton *nextButton;

@end


@implementation TCSLoginViewController

@dynamic viewModel;

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    @weakify(self);

    self.view.backgroundColor = [UIColor whiteColor];

    self.logInOutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.logInOutButton.rac_command = self.viewModel.logInOutFacebookCommand;
    [self.logInOutButton rac_liftSelector:@selector(setTitle:forState:) withSignalsFromArray:@[[RACObserve(self.viewModel, logInOutButtonText) ignore:nil], [RACSignal return:@(UIControlStateNormal)]]];
    [self.view addSubview:self.logInOutButton];

    self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.nextButton.rac_command = self.viewModel.confirmFacebookUserCommand;
    [self.nextButton setTitle:NSLocalizedString(@"Continue", nil) forState:UIControlStateNormal];
    [self.view addSubview:self.nextButton];


    [[[self.nextButton.rac_command executionSignals]
        switchToLatest]
        subscribeNext:^(TCSGroupsViewModel *groupsViewModel) {
            @strongify(self);
            TCSGroupSelectViewController *groupSelectViewController = [[TCSGroupSelectViewController alloc] initWithViewModel:groupsViewModel];
            [self.navigationController pushViewController:groupSelectViewController animated:YES];
        }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    self.logInOutButton.frame = CGRectMake(30, 60, 260, 50);

    self.nextButton.frame = CGRectMake(30, 180, 260, 50);
}

@end
