//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSLoginViewController.h"

#import <FacebookSDK/FacebookSDK.h>

#pragma mark -

@interface TCSLoginViewController () <FBLoginViewDelegate>

@property (nonatomic) FBLoginView *loginView;

@end


@implementation TCSLoginViewController

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"email, public_profile, user_groups, user_status"]];
    self.loginView.delegate = self;
    [self.view addSubview:self.loginView];

    @weakify(self);
    [[self rac_signalForSelector:@selector(loginViewShowingLoggedInUser:) fromProtocol:@protocol(FBLoginViewDelegate)]
        subscribeNext:^(id _) {
            @strongify(self);
            [self dismissViewControllerAnimated:YES completion:nil];
        }];

    [[self rac_signalForSelector:@selector(loginView:handleError:) fromProtocol:@protocol(FBLoginViewDelegate)]
        subscribeNext:^(RACTuple *t) {
            NSError *error = t.second;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    self.loginView.frame = CGRectOffset(self.loginView.frame, (self.view.center.x - (self.loginView.frame.size.width / 2)), 40);
}

@end
