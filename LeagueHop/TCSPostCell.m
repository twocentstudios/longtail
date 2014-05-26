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
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        RAC(self.nameLabel, attributedText) = RACObserve(self, viewModel.userName);
        RAC(self.postSummaryLabel, attributedText) = RACObserve(self, viewModel.postSummary);
        RAC(self.dateLabel, attributedText) = RACObserve(self, viewModel.year);
        RAC(self.messageLabel, attributedText) = RACObserve(self, viewModel.message);
        RAC(self.linkImageView, image) = RACObserve(self, viewModel.linkImage);
        RAC(self.linkNameLabel, attributedText) = RACObserve(self, viewModel.linkName);
        RAC(self.likesLabel, attributedText) = RACObserve(self, viewModel.likesSummary);
        RAC(self.commentsLabel, attributedText) = RACObserve(self, viewModel.commentsSummary);

        
    }
    return self;
}

@end
