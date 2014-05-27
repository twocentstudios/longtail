//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSWebViewController.h"


#pragma mark -

@interface TCSWebViewController () <UIWebViewDelegate>

@property (nonatomic) UIWebView *webView;

@end

@implementation TCSWebViewController

@dynamic viewModel;

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];

    [self.webView rac_liftSelector:@selector(loadRequest:) withSignalsFromArray:@[RACObserve(self, viewModel.URLRequest)]];

    RAC(self, loading) =
        [RACSignal merge:@[
            [[self.webView rac_signalForSelector:@selector(webViewDidStartLoad:) fromProtocol:@protocol(UIWebViewDelegate)] mapReplace:@YES],
            [[self.webView rac_signalForSelector:@selector(webViewDidFinishLoad:) fromProtocol:@protocol(UIWebViewDelegate)] mapReplace:@NO] ]];

    [self rac_liftSelector:@selector(presentError:) withSignalsFromArray:@[[self.webView rac_signalForSelector:@selector(webView:didFailLoadWithError:) fromProtocol:@protocol(UIWebViewDelegate)]]];
}

- (void)viewWillLayoutSubviews {
    self.webView.frame = self.view.bounds;
}

@end
