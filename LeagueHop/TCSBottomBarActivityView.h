//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#pragma mark -

@interface TCSBottomBarActivityView : UIView

@property (nonatomic, weak, readonly) UIView *barView;
@property (nonatomic, getter = isLoading) BOOL loading;
@property (nonatomic) CGFloat progress;

- (instancetype)initWithBarView:(UIView *)barView;

@end
