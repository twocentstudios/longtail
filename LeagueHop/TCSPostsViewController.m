//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSPostsViewController.h"

#import "TCSLoginViewController.h"
#import "TCSLoginViewModel.h"

#import "TCSPostViewModel.h"

#import "TCSPostCell.h"

#pragma mark -

@interface TCSPostsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;

@end


@implementation TCSPostsViewController

@dynamic viewModel;

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    @weakify(self);

    RAC(self, title) = RACObserve(self, viewModel.title);

    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:TCSPostCell.class forCellReuseIdentifier:NSStringFromClass(TCSPostCell.class)];
    [self.view addSubview:self.tableView];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:nil action:nil];
    self.navigationItem.leftBarButtonItem.rac_command = self.viewModel.loadPostsCommand;

    [[RACObserve(self, viewModel.postViewModels)
        mapReplace:self.tableView]
        subscribeNext:^(UITableView *tableView) {
            [tableView reloadData];
        }];

    [[RACObserve(self, viewModel.presentLoginSignal)
        switchToLatest]
        subscribeNext:^(TCSLoginViewModel *loginViewModel) {
            @strongify(self);
            TCSLoginViewController *loginViewController = [[TCSLoginViewController alloc] initWithViewModel:loginViewModel];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            navigationController.navigationBar.translucent = NO;
            [self presentViewController:navigationController animated:YES completion:nil];
        }];
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
    return NO;
}

@end
