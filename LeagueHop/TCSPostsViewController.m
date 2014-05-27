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

#import "TCSWebViewController.h"
#import "TCSWebViewModel.h"

#pragma mark -

@interface TCSPostsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;

// This view is used for calcuating cell heights.
@property (nonatomic) TCSPostView *mockPostView;

@end


@implementation TCSPostsViewController

@dynamic viewModel;

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    RAC(self, title) = RACObserve(self.viewModel, title);

    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:TCSPostCell.class forCellReuseIdentifier:NSStringFromClass(TCSPostCell.class)];
    [self.view insertSubview:self.tableView atIndex:0];

    self.mockPostView = [[TCSPostView alloc] init];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
    self.navigationItem.leftBarButtonItem.rac_command = self.viewModel.presentSettingsCommand;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:nil action:nil];
    self.navigationItem.rightBarButtonItem.rac_command = self.viewModel.loadPostsCommand;

    RAC(self, loading) = [self.viewModel.loadPostsCommand executing];

    [[RACObserve(self.viewModel, postViewModels)
        mapReplace:self.tableView]
        subscribeNext:^(UITableView *tableView) {
            [tableView reloadData];
        }];

    void (^presentSettingsViewController)(TCSSettingsViewModel *) = ^(TCSSettingsViewModel *loginViewModel) {
        TCSSettingsViewController *loginViewController = [[TCSSettingsViewController alloc] initWithViewModel:loginViewModel];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        navigationController.navigationBar.translucent = NO;
        [self presentViewController:navigationController animated:YES completion:nil];
    };

    [self.viewModel.shouldPresentSettingsSignal
        subscribeNext:presentSettingsViewController];

    [[[self.viewModel.presentSettingsCommand executionSignals]
        switchToLatest]
        subscribeNext:presentSettingsViewController];

}

- (void)viewWillLayoutSubviews {
    self.tableView.frame = self.view.bounds;
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
    TCSPostViewModel *viewModel = self.viewModel.postViewModels[indexPath.row];
    return [[[viewModel.openLinkCommand enabled] first] boolValue];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    @weakify(self);

    TCSPostViewModel *viewModel = self.viewModel.postViewModels[indexPath.row];
    [[viewModel.openLinkCommand execute:nil]
        subscribeNext:^(TCSWebViewModel *webViewModel) {
            @strongify(self);
            TCSWebViewController *webViewController = [[TCSWebViewController alloc] initWithViewModel:webViewModel];
            [self.navigationController pushViewController:webViewController animated:YES];
        }];
}

@end
