//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSSettingsViewController.h"

#import "TCSGroupSelectViewController.h"
#import "TCSGroupViewModel.h"

#pragma mark -

@interface TCSSettingsViewController ()

@property (nonatomic) UILabel *servicesLabel;
@property (nonatomic) UIButton *facebookServiceButton;

@property (nonatomic) UILabel *importingLabel;
@property (nonatomic) UIButton *importGroupsButton;
@property (nonatomic) UILabel *importGroupsHintLabel;

@end


@implementation TCSSettingsViewController

@dynamic viewModel;

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    @weakify(self);

    self.view.backgroundColor = [UIColor whiteColor];

    RAC(self, title) = RACObserve(self.viewModel, title);

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil) style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.leftBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [self rac_liftSelector:@selector(dismissViewControllerAnimated:completion:) withSignalsFromArray:@[[RACSignal return:@YES], [RACSignal return:nil]]];
    }];

    self.servicesLabel = [[UILabel alloc] initForAutoLayout];
    self.servicesLabel.backgroundColor = [UIColor clearColor];
    self.servicesLabel.numberOfLines = 1;
    self.servicesLabel.textColor = GRAY_DARK;
    self.servicesLabel.font = FONT_DEMIBOLD(22);
    self.servicesLabel.text = NSLocalizedString(@"Services", nil);
    [self.view addSubview:self.servicesLabel];

    self.facebookServiceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.facebookServiceButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.facebookServiceButton.backgroundColor = GRAY_WHITE;
    self.facebookServiceButton.titleLabel.font = FONT_MEDIUM(20);
    self.facebookServiceButton.rac_command = self.viewModel.logInOutFacebookCommand;
    [self.facebookServiceButton rac_liftSelector:@selector(setTitle:forState:) withSignalsFromArray:@[[RACObserve(self.viewModel, logInOutButtonText) ignore:nil], [RACSignal return:@(UIControlStateNormal)]]];
    [self.view addSubview:self.facebookServiceButton];

    self.importingLabel = [[UILabel alloc] initForAutoLayout];
    self.importingLabel.backgroundColor = [UIColor clearColor];
    self.importingLabel.numberOfLines = 1;
    self.importingLabel.textColor = GRAY_DARK;
    self.importingLabel.font = FONT_DEMIBOLD(22);
    self.importingLabel.text = NSLocalizedString(@"Importing", nil);
    [self.view addSubview:self.importingLabel];

    self.importGroupsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.importGroupsButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.importGroupsButton.backgroundColor = GRAY_WHITE;
    self.importGroupsButton.titleLabel.font = FONT_MEDIUM(20);
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

    self.importGroupsHintLabel = [[UILabel alloc] initForAutoLayout];
    self.importGroupsHintLabel.textAlignment = NSTextAlignmentCenter;
    self.importGroupsHintLabel.backgroundColor = [UIColor clearColor];
    self.importGroupsHintLabel.numberOfLines = 0;
    self.importGroupsHintLabel.textColor = GRAY_MEDIUM;
    self.importGroupsHintLabel.font = FONT_REGULAR(16);
    RAC(self.importGroupsHintLabel, text) = RACObserve(self.viewModel, importGroupsHintText);
    [self.view addSubview:self.importGroupsHintLabel];

    CGFloat const hLeftInset = 14;
    CGFloat const hRightInset = hLeftInset;
    CGFloat const vTopInset = 26;
    CGFloat const vButtonHeight = 50;
    CGFloat const vLabelButtonMargin = 6;
    CGFloat const vButtonLabelMargin = 26;

    [self.servicesLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(vTopInset, hLeftInset, 0, hRightInset) excludingEdge:ALEdgeBottom];

    [self.facebookServiceButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.servicesLabel withOffset:vLabelButtonMargin];
    [self.facebookServiceButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:hLeftInset];
    [self.facebookServiceButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:hRightInset];
    [self.facebookServiceButton autoSetDimension:ALDimensionHeight toSize:vButtonHeight];

    [self.importingLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.facebookServiceButton withOffset:vButtonLabelMargin];
    [self.importingLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:hLeftInset];
    [self.importingLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:hRightInset];

    [self.importGroupsButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.importingLabel withOffset:vLabelButtonMargin];
    [self.importGroupsButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:hLeftInset];
    [self.importGroupsButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:hRightInset];
    [self.importGroupsButton autoSetDimension:ALDimensionHeight toSize:vButtonHeight];

    [self.importGroupsHintLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.importGroupsButton withOffset:vLabelButtonMargin];
    [self.importGroupsHintLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:hLeftInset];
    [self.importGroupsHintLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:hRightInset];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.importGroupsHintLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.importGroupsHintLabel.bounds);

    [self.view layoutIfNeeded];
}

@end
