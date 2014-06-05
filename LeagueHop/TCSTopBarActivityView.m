//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSTopBarActivityView.h"

@interface TCSTopBarActivityView ()

@property (nonatomic) CABasicAnimation *pulseAnimation;

@end

#pragma mark -

@implementation TCSTopBarActivityView

#pragma mark Creation

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.translatesAutoresizingMaskIntoConstraints = NO;

        @weakify(self);

        CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@keypath(CALayer.new, backgroundColor)];
        [pulseAnimation setFromValue:(id)[UIColor whiteColor].CGColor];
        [pulseAnimation setToValue:(id)APP_TINT.CGColor];
        [pulseAnimation setDuration:0.6];
        [pulseAnimation setAutoreverses:YES];
        [pulseAnimation setRepeatCount:CGFLOAT_MAX];

        [[RACObserve(self, loading)
            distinctUntilChanged]
            subscribeNext:^(NSNumber *loading) {
                @strongify(self);
                NSString *const animationKey = @"pulseAnimation";
                if ([loading boolValue]) {
                    [self.layer addAnimation:pulseAnimation forKey:animationKey];
                } else {
                    [self.layer removeAnimationForKey:animationKey];
                }
            }];

    }
    return self;
}

#pragma mark UIView

- (void)updateConstraints {
    [super updateConstraints];

    CGFloat const vHeight = 3;
    [self autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [self autoSetDimension:ALDimensionHeight toSize:vHeight];
}

- (void)didMoveToSuperview {
    [self setNeedsUpdateConstraints];
}

@end
