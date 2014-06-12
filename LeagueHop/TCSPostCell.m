//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSPostCell.h"

#import "TCSPostView.h"

#import "TCSPostViewModel.h"

@interface TCSPostCell ()

@property (nonatomic) TCSPostView *postView;

@end

#pragma mark -

@implementation TCSPostCell

#pragma mark Creation

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        _postView = [[TCSPostView alloc] initForAutoLayout];
        [self.contentView addSubview:_postView];

        RAC(self.postView, viewModel) = RACObserve(self, viewModel);

        [_postView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    }
    return self;
}

@end
