//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewModel.h"

@interface TCSWebViewModel : TCSViewModel

@property (nonatomic, readonly) NSString *title;

@property (nonatomic, readonly) NSURLRequest *URLRequest;

- (instancetype)initWithURL:(NSURL *)URL title:(NSString *)title;

@end
