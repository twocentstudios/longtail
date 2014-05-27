//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSWebViewModel.h"
#import "TCSViewModel+Protected.h"

@interface TCSWebViewModel ()

@property (nonatomic) NSString *title;
@property (nonatomic) NSURL *URL;
@property (nonatomic) NSURLRequest *URLRequest;

@end

#pragma mark -

@implementation TCSWebViewModel

- (instancetype)initWithURL:(NSURL *)URL title:(NSString *)title {
    self = [super init];
    if (self != nil) {
        _URL = URL;
        _title = title;

        RAC(self, URLRequest) =
            [RACObserve(self, URL) map:^NSURLRequest *(NSURL *URL) {
                return [NSURLRequest requestWithURL:URL];
            }];
    }
    return self;
}

@end
