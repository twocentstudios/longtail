//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSPostsViewController.h"

#import "TCSPostViewModel.h"

#import "TCSPostCell.h"
#import "TCSPostView.h"

#import "TCSSettingsViewController.h"
#import "TCSSettingsViewModel.h"

#import "TCSLogInViewController.h"
#import "TCSLogInViewModel.h"

#import "TCSWebViewController.h"
#import "TCSWebViewModel.h"

#import "TCSInformationView.h"

#pragma mark -

@interface TCSPostsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;

@property (nonatomic) TCSInformationView *emptyView;

// This view is used for calcuating cell heights.
@property (nonatomic) TCSPostView *mockPostView;

@end


@implementation TCSPostsViewController

@dynamic viewModel;

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    @weakify(self);

    RAC(self, title) = RACObserve(self.viewModel, title);

    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:TCSPostCell.class forCellReuseIdentifier:NSStringFromClass(TCSPostCell.class)];
    [self.view insertSubview:self.tableView atIndex:0];

    self.emptyView = [[TCSInformationView alloc] initWithViewModel:self.viewModel.emptyViewModel];
    [self.view addSubview:self.emptyView];

    self.mockPostView = [[TCSPostView alloc] init];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings-icon"] style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.leftBarButtonItem.rac_command = self.viewModel.presentSettingsCommand;

    RAC(self, loading) = [self.viewModel.loadPostsCommand executing];

    [[RACObserve(self.viewModel, postViewModels)
        mapReplace:self.tableView]
        subscribeNext:^(UITableView *tableView) {
            [tableView reloadData];
        }];

    [self.viewModel.shouldPresentLogInSignal
        subscribeNext:^(TCSLogInViewModel *logInViewModel) {
            TCSLogInViewController *logInViewController = [[TCSLogInViewController alloc] initWithViewModel:logInViewModel];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:logInViewController];
            navigationController.navigationBar.translucent = NO;
            [self presentViewController:navigationController animated:YES completion:nil];
        }];

    [[[self.viewModel.presentSettingsCommand executionSignals]
        switchToLatest]
        subscribeNext:^(TCSSettingsViewModel *settingsViewModel) {
            TCSSettingsViewController *settingsViewController = [[TCSSettingsViewController alloc] initWithViewModel:settingsViewModel];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
            navigationController.navigationBar.translucent = NO;
            [self presentViewController:navigationController animated:YES completion:nil];
        }];

    [[[self.viewModel.openURLCommand executionSignals]
        switchToLatest]
        subscribeNext:^(TCSWebViewModel *webViewModel) {
            @strongify(self);
            TCSWebViewController *webViewController = [[TCSWebViewController alloc] initWithViewModel:webViewModel];
            [self.navigationController pushViewController:webViewController animated:YES];
        }];
}

- (void)viewWillLayoutSubviews {
    self.tableView.frame = self.view.bounds;
    self.emptyView.frame = self.view.bounds;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (NSInteger)[self.viewModel.postViewModels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TCSPostCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TCSPostCell.class) forIndexPath:indexPath];
	cell.viewModel = self.viewModel.postViewModels[indexPath.row];
	return cell;
}

#pragma mark UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCSPostViewModel *viewModel = self.viewModel.postViewModels[indexPath.row];
    if (viewModel.cachedViewHeight != nil) {
        return [viewModel.cachedViewHeight floatValue];
    }

    self.mockPostView.viewModel = viewModel;
    self.mockPostView.frame = self.tableView.bounds;
    [self.mockPostView setNeedsLayout];
    [self.mockPostView layoutIfNeeded];
    CGFloat const height = [self.mockPostView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    viewModel.cachedViewHeight = @(height);
    return height;
}

@end
