//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSGroupImportViewController.h"

#import "UIColor+TCSColorId.h"

#pragma mark -

@interface TCSGroupImportViewController ()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *hintLabel;

@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) UICollisionBehavior *collisionBehavior;
@property (nonatomic) UIGravityBehavior *gravityBehavior;
@property (nonatomic) NSArray *pushBehaviors;

@end


@implementation TCSGroupImportViewController

@dynamic viewModel;

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    @weakify(self);

    self.view.backgroundColor = WHITE;

    RAC(self, title) = RACObserve(self.viewModel, title);

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@keypath(CALayer.new, backgroundColor)];
    [animation setFromValue:(id)[UIColor whiteColor].CGColor];
    [animation setToValue:(id)APP_TINT.CGColor];
    [animation setDuration:2.6];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:CGFLOAT_MAX];

    self.titleLabel = [[UILabel alloc] initForAutoLayout];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textColor = APP_TINT;
    self.titleLabel.font = FONT_DEMIBOLD(22);
    [self.view addSubview:self.titleLabel];

    self.hintLabel = [[UILabel alloc] initForAutoLayout];
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    self.hintLabel.backgroundColor = [UIColor clearColor];
    self.hintLabel.numberOfLines = 1;
    self.hintLabel.textColor = GRAY_WHITE;
    self.hintLabel.font = FONT_REGULAR(16);
    self.hintLabel.text = NSLocalizedString(@"tap to pop", nil);
    [self.view addSubview:self.hintLabel];

    // Bindings
    RAC(self.titleLabel, text) = RACObserve(self.viewModel, title);

    [[[[RACObserve(self, viewModel.importCommand.executing)
        flatten]
        ignore:nil]
        distinctUntilChanged]
        subscribeNext:^(NSNumber *executing) {
            @strongify(self);
            if ([executing boolValue]) {
                [self.view.layer addAnimation:animation forKey:@"background"];
                [self addDynamicLabelToViewWithText:@"0"];
            } else {
                [self.view.layer removeAnimationForKey:@"background"];
            }
        }];

    [self.viewModel.importedPostsCountsSignal
        subscribeNext:^(NSString *countString) {
            @strongify(self);
            [self addDynamicLabelToViewWithText:countString];
        } completed:^{
            @strongify(self);
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];

    // Layout
    [self.titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(50, 10, 0, 10) excludingEdge:ALEdgeBottom];
    [self.hintLabel autoCenterInSuperview];

    // UIDynamics
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:nil];
    [self.collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsZero];
    [self.animator addBehavior:self.collisionBehavior];

    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:nil];
    [self.animator addBehavior:self.gravityBehavior];

    self.pushBehaviors = @[];

    // UIGestures
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

// Creates a new label with the supplied text and adds it to the view and dynamics system
- (void)addDynamicLabelToViewWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 1;
    label.textColor = [UIColor brightColorForNumber:@([text integerValue])];
    label.font = FONT_DEMIBOLD(40);
    label.text = text;
    [self.view addSubview:label];

    [label sizeToFit];
    CGRect labelRect = label.bounds;
    labelRect.origin.x = CGRectGetMidX(self.view.bounds) - CGRectGetWidth(labelRect)/2.0f;
    labelRect.origin.y = 0;
    label.frame = labelRect;

    [self.collisionBehavior addItem:label];
    [self.gravityBehavior addItem:label];

    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[label] mode:UIPushBehaviorModeInstantaneous];
    [pushBehavior setAngle:0 magnitude:0];
    [self.animator addBehavior:pushBehavior];

    self.pushBehaviors = [self.pushBehaviors arrayByAddingObject:pushBehavior];
}

- (void)didTapView:(UIGestureRecognizer *)gesture {
    if (gesture.state != UIGestureRecognizerStateRecognized) {
        return;
    }

    for (UIPushBehavior *pushBehavior in self.pushBehaviors) {
        CGFloat angle = M_PI_2+(((NSInteger)arc4random_uniform(100)-50)/84.0f);
        [pushBehavior setAngle:angle magnitude:10];
        [pushBehavior setActive:YES];
    }
}

@end
