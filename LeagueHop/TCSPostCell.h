//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

@class TCSPostViewModel;
@class TCSPostView;

@interface TCSPostCell : UITableViewCell

@property (nonatomic) TCSPostViewModel *viewModel;

@property (nonatomic, readonly) TCSPostView *postView;

@end
