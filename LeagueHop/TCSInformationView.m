//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSInformationView.h"

#import "TCSInformationViewModel.h"

@interface TCSInformationView ()

@property (nonatomic) TCSInformationViewModel *viewModel;

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *subtitleLabel;

@end

#pragma mark -

@implementation TCSInformationView

#pragma mark Creation

- (instancetype)initWithViewModel:(TCSInformationViewModel *)viewModel {
    self = [super initWithFrame:CGRectZero];
    if (self != nil) {
        _viewModel = viewModel;

        self.backgroundColor = WHITE;

        _titleLabel = [[UILabel alloc] initForAutoLayout];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = GRAY_MEDIUM;
        _titleLabel.font = FONT_DEMIBOLD(22);
        [self addSubview:_titleLabel];

        _subtitleLabel = [[UILabel alloc] initForAutoLayout];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel.numberOfLines = 0;
        _subtitleLabel.textColor = GRAY_LIGHT;
        _subtitleLabel.font = FONT_DEMIBOLD(16);
        [self addSubview:_subtitleLabel];

        // bindings
        RAC(self.titleLabel, text) = RACObserve(self.viewModel, title);
        RAC(self.subtitleLabel, text) = RACObserve(self.viewModel, subtitle);
        RAC(self, hidden) = RACObserve(self.viewModel, hidden);
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];

    if ([self.constraints count] > 0) return;
    
    CGFloat const vLabelMargin = -4;
    CGFloat const hWidthMultiplier = 0.8;

    [self.subtitleLabel autoCenterInSuperview];
    [self.subtitleLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.superview withMultiplier:hWidthMultiplier];

    [self.titleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.subtitleLabel withOffset:vLabelMargin];
    [self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.titleLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.superview withMultiplier:hWidthMultiplier];
}

@end
