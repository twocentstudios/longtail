//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSPostView.h"

#import "TCSPostViewModel.h"

#import <TTTAttributedLabel/TTTAttributedLabel.h>

@interface TCSPostView () <TTTAttributedLabelDelegate>

@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *postSummaryLabel;
@property (nonatomic) UILabel *dateLabel;
@property (nonatomic) TTTAttributedLabel *messageLabel;
@property (nonatomic) UILabel *likesLabel;
@property (nonatomic) TTTAttributedLabel *commentsLabel;

@end

@implementation TCSPostView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        // View creation
        self.nameLabel = [[UILabel alloc] initForAutoLayout];
        self.nameLabel.numberOfLines = 1;
        [self addSubview:self.nameLabel];

        self.postSummaryLabel = [[UILabel alloc] initForAutoLayout];
        self.postSummaryLabel.numberOfLines = 1;
        [self addSubview:self.postSummaryLabel];

        self.dateLabel = [[UILabel alloc] initForAutoLayout];
        self.dateLabel.numberOfLines = 1;
        [self addSubview:self.dateLabel];

        self.messageLabel = [[TTTAttributedLabel alloc] initForAutoLayout];
        self.messageLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        self.messageLabel.textInsets = UIEdgeInsetsMake(-4, 0, 4, 0); // fix TTT layout issue
        self.messageLabel.delegate = self;
        self.messageLabel.numberOfLines = 0;
        [self addSubview:self.messageLabel];

        self.likesLabel = [[UILabel alloc] initForAutoLayout];
        self.likesLabel.numberOfLines = 0;
        [self addSubview:self.likesLabel];

        self.commentsLabel = [[TTTAttributedLabel alloc] initForAutoLayout];
        self.commentsLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        self.commentsLabel.textInsets = UIEdgeInsetsMake(-4, 0, 4, 0); // fix TTT layout issue
        self.commentsLabel.delegate = self;
        self.commentsLabel.numberOfLines = 0;
        [self addSubview:self.commentsLabel];

        // Data bindings
        RAC(self.nameLabel, attributedText) = RACObserve(self, viewModel.userName);
        RAC(self.postSummaryLabel, attributedText) = RACObserve(self, viewModel.postSummary);
        RAC(self.dateLabel, attributedText) = RACObserve(self, viewModel.year);
        [self.messageLabel rac_liftSelector:@selector(setText:) withSignalsFromArray:@[RACObserve(self, viewModel.message)]];
        RAC(self.likesLabel, attributedText) = RACObserve(self, viewModel.likesSummary);
        [self.commentsLabel rac_liftSelector:@selector(setText:) withSignalsFromArray:@[RACObserve(self, viewModel.commentsSummary)]];

        // AutoLayout
        CGFloat const hLeftSuperInset = 20;
        CGFloat const hRightSuperInset = hLeftSuperInset;
        CGFloat const vTopSuperInset = 16;
        CGFloat const vBottomSuperInset = vTopSuperInset;

        CGFloat const vComponentMargin = 14;

        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:hLeftSuperInset];
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:vTopSuperInset];
        [self.nameLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.dateLabel withOffset:10]; // TODO: not sure if we need this for max width

        [self.postSummaryLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:hLeftSuperInset];
        [self.postSummaryLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:0];

        [self.dateLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:hRightSuperInset];
        [self.dateLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:vTopSuperInset];

        [self.messageLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:hLeftSuperInset];
        [self.messageLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:hRightSuperInset];
        [self.messageLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.postSummaryLabel withOffset:vComponentMargin];

        [self.likesLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.messageLabel withOffset:vComponentMargin];
        [self.likesLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:hLeftSuperInset];
        [self.likesLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:hRightSuperInset];

        [self.commentsLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.likesLabel withOffset:8];
        [self.commentsLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:hLeftSuperInset];
        [self.commentsLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:hRightSuperInset];
        [self.commentsLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:vBottomSuperInset];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.messageLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.messageLabel.bounds);
    self.likesLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.likesLabel.bounds);
    self.commentsLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.commentsLabel.bounds);

    [super layoutSubviews];
}

# pragma mark TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [self.viewModel.openURLCommand execute:url];
}

@end
