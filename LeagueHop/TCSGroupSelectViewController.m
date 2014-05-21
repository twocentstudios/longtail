//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSGroupSelectViewController.h"

#import "TCSGroupViewModel.h"
#import "TCSGroupImportViewModel.h"

#import "TCSGroupImportViewController.h"

#import "TCSGroupCell.h"

@interface TCSGroupSelectViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;

@end


@implementation TCSGroupSelectViewController

@dynamic viewModel;

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    @weakify(self);

    RAC(self, title) = RACObserve(self, viewModel.title);

    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:TCSGroupCell.class forCellReuseIdentifier:NSStringFromClass(TCSGroupCell.class)];
    [self.view addSubview:self.tableView];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:nil action:nil];
    self.navigationItem.leftBarButtonItem.rac_command = self.viewModel.loadGroupsCommand;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", nil) style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.rightBarButtonItem.rac_command = self.viewModel.confirmSelectionCommand;

    [[RACObserve(self, viewModel.groupViewModels)
        mapReplace:self.tableView]
        subscribeNext:^(UITableView *tableView) {
            [tableView reloadData];
        }];

    [[[RACObserve(self, viewModel.confirmSelectionCommand)
        flattenMap:^RACSignal *(RACCommand *confirmSelectionCommand) {
            return [[confirmSelectionCommand executionSignals] switchToLatest];
        }]
        map:^TCSGroupImportViewController *(TCSGroupImportViewModel *importViewModel) {
            return [[TCSGroupImportViewController alloc] initWithViewModel:importViewModel];
        }]
        subscribeNext:^(TCSGroupImportViewController *viewController) {
            @strongify(self);
            [self.navigationController pushViewController:viewController animated:YES];
        }];
}

- (void)viewWillLayoutSubviews {
    self.tableView.frame = self.view.bounds;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (NSInteger)[self.viewModel.groupViewModels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TCSGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TCSGroupCell.class) forIndexPath:indexPath];
	cell.viewModel = self.viewModel.groupViewModels[indexPath.row];
	return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TCSGroupViewModel *viewModel = self.viewModel.groupViewModels[indexPath.row];
    viewModel.selected = !viewModel.selected;
}

@end
