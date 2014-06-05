//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#pragma mark -

// A simple thin bar that's pinned to the top of its superview and pulses
// from white to the app's tint color when loading is YES.
@interface TCSTopBarActivityView : UIView

@property (nonatomic, getter = isLoading) BOOL loading;

@end
