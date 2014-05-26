//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSPostCell.h"

#import "TCSPostViewModel.h"

@interface TCSPostCell ()

@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *postSummaryLabel;
@property (nonatomic) UILabel *dateLabel;
@property (nonatomic) UILabel *messageLabel;
@property (nonatomic) UIImageView *linkImageView;
@property (nonatomic) UILabel *linkNameLabel;
@property (nonatomic) UILabel *likesLabel;
@property (nonatomic) UILabel *commentsLabel;

@end

#pragma mark -

@implementation TCSPostCell

#pragma mark Creation

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {

        // View creation
        self.nameLabel = [[UILabel alloc] initForAutoLayout];
        self.nameLabel.numberOfLines = 1;
        [self.contentView addSubview:self.nameLabel];

        self.postSummaryLabel = [[UILabel alloc] initForAutoLayout];
        self.postSummaryLabel.numberOfLines = 1;
        [self.contentView addSubview:self.postSummaryLabel];

        self.dateLabel = [[UILabel alloc] initForAutoLayout];
        self.dateLabel.numberOfLines = 1;
        [self.contentView addSubview:self.dateLabel];

        self.messageLabel = [[UILabel alloc] initForAutoLayout];
        self.messageLabel.numberOfLines = 0;
        [self.contentView addSubview:self.messageLabel];

        self.linkImageView = [[UIImageView alloc] initForAutoLayout];
        self.linkImageView.backgroundColor = GRAY_LIGHT;
        [self.contentView addSubview:self.linkImageView];

        self.linkNameLabel = [[UILabel alloc] initForAutoLayout];
        self.linkNameLabel.numberOfLines = 2;
        [self.contentView addSubview:self.linkNameLabel];

        self.likesLabel = [[UILabel alloc] initForAutoLayout];
        self.likesLabel.numberOfLines = 0;
        [self.contentView addSubview:self.likesLabel];

        self.commentsLabel = [[UILabel alloc] initForAutoLayout];
        self.commentsLabel.numberOfLines = 0;
        [self.contentView addSubview:self.commentsLabel];

        // Data bindings
        RAC(self.nameLabel, attributedText) = RACObserve(self, viewModel.userName);
        RAC(self.postSummaryLabel, attributedText) = RACObserve(self, viewModel.postSummary);
        RAC(self.dateLabel, attributedText) = RACObserve(self, viewModel.year);
        RAC(self.messageLabel, attributedText) = RACObserve(self, viewModel.message);
        RAC(self.linkImageView, image) = RACObserve(self, viewModel.linkImage);
        RAC(self.linkNameLabel, attributedText) = RACObserve(self, viewModel.linkName);
        RAC(self.likesLabel, attributedText) = RACObserve(self, viewModel.likesSummary);
        RAC(self.commentsLabel, attributedText) = RACObserve(self, viewModel.commentsSummary);

        // AutoLayout
        CGFloat const hLeftSuperInset = 20;
        CGFloat const hRightSuperInset = hLeftSuperInset;
        CGFloat const vTopSuperInset = 16;
        __unused CGFloat const vBottomSuperInset = vTopSuperInset;

        CGFloat const vComponentMargin = 18;

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

        CGFloat const linkImageSide = 50;
        [self.linkImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:hLeftSuperInset];
        [self.linkImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.messageLabel withOffset:vComponentMargin];
        [self.linkImageView autoSetDimensionsToSize:CGSizeMake(linkImageSide, linkImageSide)];

        [self.linkNameLabel autoConstrainAttribute:ALAxisHorizontal toAttribute:ALAxisHorizontal ofView:self.linkImageView];
        [self.linkNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.linkImageView withOffset:14];
        [self.linkNameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:hRightSuperInset];

        [self.likesLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.linkImageView withOffset:vComponentMargin];
        [self.likesLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:hLeftSuperInset];
        [self.likesLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:hRightSuperInset];

        [self.commentsLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.likesLabel withOffset:8];
        [self.commentsLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:hLeftSuperInset];
        [self.commentsLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:hRightSuperInset];
    }
    return self;
}

@end
