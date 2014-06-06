//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSSettingsViewController.h"

#import "TCSGroupSelectViewController.h"

#import "TCSWebViewController.h"

#pragma mark -

@interface TCSSettingsViewController ()

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIView *contentView;

@property (nonatomic) UILabel *servicesLabel;
@property (nonatomic) UIButton *facebookServiceButton;

@property (nonatomic) UILabel *importingLabel;
@property (nonatomic) UIButton *importGroupsButton;
@property (nonatomic) UILabel *importGroupsHintLabel;
@property (nonatomic) UIButton *deleteAllButton;
@property (nonatomic) UILabel *deleteAllHintLabel;

@property (nonatomic) UILabel *creditsLabel;
@property (nonatomic) UIButton *authorButton;
@property (nonatomic) UIButton *licencesButton;

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

    // Quick summary of scrollView+autolayout madness:
    // The scrollView wraps itself to view.
    // scrollView.contentSize wraps itself to contentView's size.
    // contentView holds all the subviews.
    // contentView is locked to view's width.
    // contentView extends to fit its subviews' heights.
    self.scrollView = [[UIScrollView alloc] initForAutoLayout];
    [self.view addSubview:self.scrollView];

    self.contentView = [[UIView alloc] initForAutoLayout];
    [self.scrollView addSubview:self.contentView];

    self.servicesLabel = [[UILabel alloc] initForAutoLayout];
    self.servicesLabel.backgroundColor = [UIColor clearColor];
    self.servicesLabel.numberOfLines = 1;
    self.servicesLabel.textColor = GRAY_DARK;
    self.servicesLabel.font = FONT_DEMIBOLD(22);
    self.servicesLabel.text = NSLocalizedString(@"Services", nil);
    [self.contentView addSubview:self.servicesLabel];

    self.facebookServiceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.facebookServiceButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.facebookServiceButton.backgroundColor = GRAY_WHITE;
    self.facebookServiceButton.titleLabel.font = FONT_MEDIUM(20);
    [self.facebookServiceButton rac_liftSelector:@selector(setTitle:forState:) withSignalsFromArray:@[[RACObserve(self.viewModel, logInOutButtonText) ignore:nil], [RACSignal return:@(UIControlStateNormal)]]];
    [self.contentView addSubview:self.facebookServiceButton];

    self.importingLabel = [[UILabel alloc] initForAutoLayout];
    self.importingLabel.backgroundColor = [UIColor clearColor];
    self.importingLabel.numberOfLines = 1;
    self.importingLabel.textColor = GRAY_DARK;
    self.importingLabel.font = FONT_DEMIBOLD(22);
    self.importingLabel.text = NSLocalizedString(@"Importing", nil);
    [self.contentView addSubview:self.importingLabel];

    self.importGroupsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.importGroupsButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.importGroupsButton.backgroundColor = GRAY_WHITE;
    self.importGroupsButton.titleLabel.font = FONT_MEDIUM(20);
    [self.importGroupsButton rac_liftSelector:@selector(setTitle:forState:) withSignalsFromArray:@[[RACObserve(self.viewModel, importGroupsButtonText) ignore:nil], [RACSignal return:@(UIControlStateNormal)]]];
    [self.contentView addSubview:self.importGroupsButton];

    self.importGroupsHintLabel = [[UILabel alloc] initForAutoLayout];
    self.importGroupsHintLabel.textAlignment = NSTextAlignmentCenter;
    self.importGroupsHintLabel.backgroundColor = [UIColor clearColor];
    self.importGroupsHintLabel.numberOfLines = 0;
    self.importGroupsHintLabel.textColor = GRAY_MEDIUM;
    self.importGroupsHintLabel.font = FONT_REGULAR(14);
    RAC(self.importGroupsHintLabel, text) = RACObserve(self.viewModel, importGroupsHintText);
    [self.contentView addSubview:self.importGroupsHintLabel];

    self.deleteAllButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.deleteAllButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.deleteAllButton.backgroundColor = WARNING_RED;
    self.deleteAllButton.titleLabel.font = FONT_MEDIUM(20);
    [self.deleteAllButton setTitleColor:WHITE forState:UIControlStateNormal];
    [self.deleteAllButton setTitleColor:WHITEA(0.6) forState:UIControlStateDisabled];
    [self.deleteAllButton rac_liftSelector:@selector(setTitle:forState:) withSignalsFromArray:@[[RACObserve(self.viewModel, deleteAllButtonText) ignore:nil], [RACSignal return:@(UIControlStateNormal)]]];
    [self.contentView addSubview:self.deleteAllButton];

    self.deleteAllHintLabel = [[UILabel alloc] initForAutoLayout];
    self.deleteAllHintLabel.textAlignment = NSTextAlignmentCenter;
    self.deleteAllHintLabel.backgroundColor = [UIColor clearColor];
    self.deleteAllHintLabel.numberOfLines = 0;
    self.deleteAllHintLabel.textColor = GRAY_MEDIUM;
    self.deleteAllHintLabel.font = FONT_REGULAR(14);
    self.deleteAllHintLabel.text = NSLocalizedString(@"WARNING: this will delete all posts from your local device only. Your posts will have to be imported from the server again.", nil);
    [self.contentView addSubview:self.deleteAllHintLabel];

    self.creditsLabel = [[UILabel alloc] initForAutoLayout];
    self.creditsLabel.backgroundColor = [UIColor clearColor];
    self.creditsLabel.numberOfLines = 1;
    self.creditsLabel.textColor = GRAY_DARK;
    self.creditsLabel.font = FONT_DEMIBOLD(22);
    self.creditsLabel.text = NSLocalizedString(@"Credits", nil);
    [self.contentView addSubview:self.creditsLabel];

    self.authorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.authorButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.authorButton.backgroundColor = GRAY_WHITE;
    self.authorButton.titleLabel.font = FONT_MEDIUM(20);
    [self.authorButton rac_liftSelector:@selector(setTitle:forState:) withSignalsFromArray:@[[RACObserve(self.viewModel, authorText) ignore:nil], [RACSignal return:@(UIControlStateNormal)]]];
    [self.contentView addSubview:self.authorButton];

    self.licencesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.licencesButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.licencesButton.backgroundColor = GRAY_WHITE;
    self.licencesButton.titleLabel.font = FONT_MEDIUM(20);
    [self.licencesButton rac_liftSelector:@selector(setTitle:forState:) withSignalsFromArray:@[[RACObserve(self.viewModel, licensesText) ignore:nil], [RACSignal return:@(UIControlStateNormal)]]];
    [self.contentView addSubview:self.licencesButton];

    // Bindings
    self.facebookServiceButton.rac_command = self.viewModel.logInOutFacebookCommand;
    self.importGroupsButton.rac_command = self.viewModel.presentGroupImportCommand;
    self.deleteAllButton.rac_command = self.viewModel.deleteAllCommand;
    self.authorButton.rac_command = self.viewModel.presentAuthorCommand;
    self.licencesButton.rac_command = self.viewModel.presentLicensesCommand;

    [[[self.importGroupsButton.rac_command executionSignals]
        switchToLatest]
        subscribeNext:^(TCSGroupsViewModel *groupsViewModel) {
            @strongify(self);
            TCSGroupSelectViewController *groupSelectViewController = [[TCSGroupSelectViewController alloc] initWithViewModel:groupsViewModel];
            [self.navigationController pushViewController:groupSelectViewController animated:YES];
        }];

    [[[RACSignal
        merge:@[[self.authorButton.rac_command executionSignals],
                [self.licencesButton.rac_command executionSignals]]]
        switchToLatest]
        subscribeNext:^(TCSWebViewModel *webViewModel) {
            @strongify(self);
            TCSWebViewController *webViewController = [[TCSWebViewController alloc] initWithViewModel:webViewModel];
            [self.navigationController pushViewController:webViewController animated:YES];
        }];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    if ([self.contentView.constraints count] > 0) return;

    CGFloat const hLeftInset = 14;
    CGFloat const hRightInset = hLeftInset;
    CGFloat const vTopInset = 26;
    CGFloat const vBottomInset = vTopInset;
    CGFloat const vButtonHeight = 50;
    CGFloat const vLabelButtonMargin = 6;
    CGFloat const vButtonLabelMargin = 26;

    [self.scrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self.contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self.contentView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];

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

    [self.deleteAllButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.importGroupsHintLabel withOffset:vButtonLabelMargin];
    [self.deleteAllButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:hLeftInset];
    [self.deleteAllButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:hRightInset];
    [self.deleteAllButton autoSetDimension:ALDimensionHeight toSize:vButtonHeight];

    [self.deleteAllHintLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.deleteAllButton withOffset:vLabelButtonMargin];
    [self.deleteAllHintLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:hLeftInset];
    [self.deleteAllHintLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:hRightInset];

    [self.creditsLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.deleteAllHintLabel withOffset:vButtonLabelMargin];
    [self.creditsLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:hLeftInset];
    [self.creditsLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:hRightInset];

    [self.authorButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.creditsLabel withOffset:vLabelButtonMargin];
    [self.authorButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:hLeftInset];
    [self.authorButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:hRightInset];
    [self.authorButton autoSetDimension:ALDimensionHeight toSize:vButtonHeight];

    [self.licencesButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.authorButton withOffset:vLabelButtonMargin];
    [self.licencesButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:hLeftInset];
    [self.licencesButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:hRightInset];
    [self.licencesButton autoSetDimension:ALDimensionHeight toSize:vButtonHeight];
    [self.licencesButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:vBottomInset];
}

@end
