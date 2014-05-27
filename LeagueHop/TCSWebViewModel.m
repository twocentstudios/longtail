//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSWebViewModel.h"
#import "TCSViewModel+Protected.h"

@interface TCSWebViewModel ()

@property (nonatomic) NSURL *URL;
@property (nonatomic) NSURLRequest *URLRequest;

@end

#pragma mark -

@implementation TCSWebViewModel

- (instancetype)initWithURL:(NSURL *)URL {
    self = [super init];
    if (self != nil) {
        _URL = URL;

        RAC(self, URLRequest) =
            [RACObserve(self, URL) map:^NSURLRequest *(NSURL *URL) {
                return [NSURLRequest requestWithURL:URL];
            }];
    }
    return self;
}

@end
