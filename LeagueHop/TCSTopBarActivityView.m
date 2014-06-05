//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSTopBarActivityView.h"

@interface TCSTopBarActivityView ()

@property (nonatomic, getter = isShowingLoading) BOOL showingLoading;

@property (nonatomic) CABasicAnimation *pulseAnimation;
@property (nonatomic) CALayer *maskLayer;

@end

#pragma mark -

@implementation TCSTopBarActivityView

#pragma mark Creation

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        _progress = 1;

        self.translatesAutoresizingMaskIntoConstraints = NO;

        @weakify(self);

        self.pulseAnimation = [CABasicAnimation animationWithKeyPath:@keypath(CALayer.new, backgroundColor)];
        [self.pulseAnimation setFromValue:(id)[UIColor whiteColor].CGColor];
        [self.pulseAnimation setToValue:(id)APP_TINT.CGColor];
        [self.pulseAnimation setDuration:0.6];
        [self.pulseAnimation setAutoreverses:YES];
        [self.pulseAnimation setRepeatCount:CGFLOAT_MAX];

        self.maskLayer = [CALayer layer];
        [self.maskLayer setBackgroundColor:BLACK.CGColor];
        [self.layer setMask:self.maskLayer];

        RAC(self, showingLoading) =
            [[RACSignal combineLatest:@[RACObserve(self, loading), RACObserve(self, progress)]]
                reduceEach:^NSNumber *(NSNumber *loading, NSNumber *progress) {
                    return @([loading boolValue] || ([progress floatValue] != 1));
                }];

        [[RACObserve(self, progress)
            map:^NSNumber *(NSNumber *progress) {
                if ([progress floatValue] > 1) {
                    return @1;
                } else if ([progress floatValue] < 0) {
                    return @0;
                } else {
                    return progress;
                }
            }]
            subscribeNext:^(NSNumber *progress) {
                @strongify(self);
                [self setNeedsLayout];
            }];

        [[RACObserve(self, showingLoading)
            distinctUntilChanged]
            subscribeNext:^(NSNumber *loading) {
                @strongify(self);
                if ([loading boolValue]) {
                    [self.layer addAnimation:self.pulseAnimation forKey:@keypath(self, pulseAnimation)];
                } else {
                    [self.layer removeAnimationForKey:@keypath(self, pulseAnimation)];
                }
            }];

    }
    return self;
}

#pragma mark UIView

- (void)updateConstraints {
    [super updateConstraints];

    CGFloat const vHeight = 3;
    [self.maskLayer setFrame:CGRectMake(0, 0, 0, vHeight)];
    [self autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [self autoSetDimension:ALDimensionHeight toSize:vHeight];
}

- (void)layoutSubviews {
    CGRect maskRect = [self.maskLayer frame];
    maskRect.size.width = CGRectGetWidth([self bounds]) * self.progress;
    [self.maskLayer setFrame:maskRect];
}

- (void)didMoveToSuperview {
    [self setNeedsUpdateConstraints];
}

@end
