//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewModel.h"

// Represents a URLRequest that can be loaded by a UIWebView and an optional title.
// Basically converts a URL->URLRequest because UIWebViews are pretty full featured.
@interface TCSWebViewModel : TCSViewModel

@property (nonatomic, readonly) NSString *title;

@property (nonatomic, readonly) NSURLRequest *URLRequest;

- (instancetype)initWithURL:(NSURL *)URL title:(NSString *)title;

@end
