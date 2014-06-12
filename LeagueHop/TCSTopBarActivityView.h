//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

// A simple, thin and fixed height bar that pulses
// from white to the app's tint color when loading is YES.
@interface TCSTopBarActivityView : UIView

@property (nonatomic, getter = isLoading) BOOL loading;

@end
