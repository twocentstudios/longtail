//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSSettingsViewController.h"

#import "TCSGroupSelectViewController.h"
#import "TCSGroupViewModel.h"

#pragma mark -

@interface TCSSettingsViewController ()

@property (nonatomic) UIButton *logInOutButton;

@property (nonatomic) UIButton *importGroupsButton;

@end


@implementation TCSSettingsViewController

@dynamic viewModel;

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    @weakify(self);

    self.view.backgroundColor = [UIColor whiteColor];

    RAC(self, title) = RACObserve(self, viewModel.title);

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil) style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.leftBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [self rac_liftSelector:@selector(dismissViewControllerAnimated:completion:) withSignalsFromArray:@[[RACSignal return:@YES], [RACSignal return:nil]]];
    }];

    self.logInOutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.logInOutButton.rac_command = self.viewModel.logInOutFacebookCommand;
    [self.logInOutButton rac_liftSelector:@selector(setTitle:forState:) withSignalsFromArray:@[[RACObserve(self.viewModel, logInOutButtonText) ignore:nil], [RACSignal return:@(UIControlStateNormal)]]];
    [self.view addSubview:self.logInOutButton];

    self.importGroupsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.importGroupsButton.rac_command = self.viewModel.presentGroupImportCommand;
    [self.importGroupsButton rac_liftSelector:@selector(setTitle:forState:) withSignalsFromArray:@[[RACObserve(self.viewModel, importGroupsButtonText) ignore:nil], [RACSignal return:@(UIControlStateNormal)]]];
    [self.view addSubview:self.importGroupsButton];

    [[[self.importGroupsButton.rac_command executionSignals]
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

    self.importGroupsButton.frame = CGRectMake(30, 180, 260, 50);
}

@end
