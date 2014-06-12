//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSLogInViewController.h"

#import "TCSGroupSelectViewController.h"

@interface TCSLogInViewController ()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *subtitleLabel;

@property (nonatomic) UIButton *logInButton;

@end

#pragma mark -

@implementation TCSLogInViewController

@dynamic viewModel;

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    @weakify(self);

    self.view.backgroundColor = WHITE;

    self.titleLabel = [[UILabel alloc] initForAutoLayout];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textColor = APP_TINT;
    self.titleLabel.font = FONT_DEMIBOLD(28);
    RAC(self.titleLabel, text) = RACObserve(self.viewModel, title);
    [self.view addSubview:self.titleLabel];

    self.subtitleLabel = [[UILabel alloc] initForAutoLayout];
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subtitleLabel.backgroundColor = [UIColor clearColor];
    self.subtitleLabel.numberOfLines = 0;
    self.subtitleLabel.textColor = GRAY_MEDIUM;
    self.subtitleLabel.font = FONT_REGULAR(20);
    RAC(self.subtitleLabel, text) = RACObserve(self.viewModel, subtitle);
    [self.view addSubview:self.subtitleLabel];

    self.logInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.logInButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.logInButton.backgroundColor = APP_TINT;
    self.logInButton.titleLabel.font = FONT_MEDIUM(20);
    [self.logInButton setTitleColor:WHITE forState:UIControlStateNormal];
    self.logInButton.rac_command = self.viewModel.logInFacebookCommand;
    [self.logInButton rac_liftSelector:@selector(setTitle:forState:) withSignalsFromArray:@[[RACObserve(self.viewModel, logInButtonText) ignore:nil], [RACSignal return:@(UIControlStateNormal)]]];
    [self.view addSubview:self.logInButton];

    [[[[RACSignal
        combineLatest:@[ [RACObserve(self.viewModel, groupsViewModel) ignore:nil],
                         RACObserve(self.viewModel, active) ]
        reduce:^TCSGroupsViewModel *(TCSGroupsViewModel *viewModel, NSNumber *active){
            return [active boolValue] ? viewModel : nil;
        }]
        ignore:nil]
        delay:0.25]
        subscribeNext:^(TCSGroupsViewModel *groupsViewModel) {
            @strongify(self);
            TCSGroupSelectViewController *viewController = [[TCSGroupSelectViewController alloc] initWithViewModel:groupsViewModel];
            [self.navigationController pushViewController:viewController animated:YES];
        }];

    // layout
    CGFloat const vTopInset = 90;
    CGFloat const vBottomInset = 30;
    CGFloat const hLeftInset = 14;
    CGFloat const hRightInset = hLeftInset;
    CGFloat const vInterTitleInset = 24;
    CGFloat const vButtonHeight = 50;

    [self.titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(vTopInset, hLeftInset, 0, hRightInset) excludingEdge:ALEdgeBottom];

    [self.subtitleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:hLeftInset];
    [self.subtitleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:hRightInset];
    [self.subtitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:vInterTitleInset];
    
    [self.logInButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, hLeftInset, vBottomInset, hRightInset) excludingEdge:ALEdgeTop];
    [self.logInButton autoSetDimension:ALDimensionHeight toSize:vButtonHeight];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
