//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSWebViewController.h"

@interface TCSWebViewController () <UIWebViewDelegate>

@property (nonatomic) UIWebView *webView;

@end

#pragma mark -

@implementation TCSWebViewController

@dynamic viewModel;

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    RAC(self, title) = RACObserve(self.viewModel, title);

    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    [self.view insertSubview:self.webView atIndex:0];

    [self.webView rac_liftSelector:@selector(loadRequest:) withSignalsFromArray:@[RACObserve(self, viewModel.URLRequest)]];

    [self rac_liftSelector:@selector(presentError:) withSignalsFromArray:@[[self.webView rac_signalForSelector:@selector(webView:didFailLoadWithError:) fromProtocol:@protocol(UIWebViewDelegate)]]];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    self.webView.frame = self.view.bounds;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.loading = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.loading = NO;
}

@end
