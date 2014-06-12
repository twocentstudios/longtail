//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

@class TCSPostViewModel;
@class TCSPostView;

// TableViewCell that wraps a post view.
@interface TCSPostCell : UITableViewCell

@property (nonatomic) TCSPostViewModel *viewModel;

@property (nonatomic, readonly) TCSPostView *postView;

@end
