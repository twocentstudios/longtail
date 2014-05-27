//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewModel.h"

#pragma mark -

@interface TCSWebViewModel : TCSViewModel

@property (nonatomic, readonly) NSURLRequest *URLRequest;

- (instancetype)initWithURL:(NSURL *)URL;

@end
