//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSLoginViewModel.h"
#import "TCSViewModel+Protected.h"

#import "TCSPostController.h"
#import <FacebookSDK/FacebookSDK.h>

#import "TCSGroupsViewModel.h"

@interface TCSLoginViewModel ()

@property (nonatomic) NSString *loginButtonText;

@property (nonatomic, getter = isLoading) BOOL loading;

@property (nonatomic) RACCommand *logInToFacebookCommand;
@property (nonatomic) RACCommand *logOutOfFacebookCommand;
@property (nonatomic) RACCommand *reauthenticateFacebookCommand;
@property (nonatomic) RACCommand *confirmFacebookUserCommand;

@property (nonatomic) TCSPostController *controller;

@end

#pragma mark -

@implementation TCSLoginViewModel

- (instancetype)initWithController:(TCSPostController *)controller {
    NSParameterAssert(controller);

    self = [super init];
    if (self != nil) {
        _controller = controller;

        @weakify(self);

        RAC(self, loginButtonText) =
            [[TCSPostController facebookSession]
                map:^NSString *(FBSession *session) {
                    if (session.state == FBSessionStateCreated) {
                        return NSLocalizedString(@"Login with Facebook", nil);
                    } else if (session.state == FBSessionStateCreatedOpening || FBSessionStateCreatedTokenLoaded) {
                        return NSLocalizedString(@"Logging in...", nil);
                    } else if (session.state == FBSessionStateOpen || session.state == FBSessionStateOpenTokenExtended) {
                        return NSLocalizedString(@"Log out", nil);
                    } else {
                        return @"";
                    }
                }];

        RACSignal *logInEnabled =
            [[TCSPostController facebookSession]
                map:^NSNumber *(FBSession *session) {
                    if (session.state == FBSessionStateCreated) {
                        return @YES;
                    } else {
                        return @NO;
                    }
                }];

        RACSignal *logOutEnabled =
            [[TCSPostController facebookSession]
                map:^NSNumber *(FBSession *session) {
                    if (session.state == FBSessionStateOpen || session.state == FBSessionStateOpenTokenExtended) {
                        return @YES;
                    } else {
                        return @NO;
                    }
                }];

        RACSignal *reauthenticateEnabled =
            [[TCSPostController facebookSession]
                map:^NSNumber *(FBSession *session) {
                    if (session.state == FBSessionStateCreatedTokenLoaded) {
                        return @YES;
                    } else {
                        return @NO;
                    }
                }];

        _confirmFacebookUserCommand = [[RACCommand alloc] initWithEnabled:logOutEnabled signalBlock:^RACSignal *(id _) {
            @strongify(self);
            TCSGroupsViewModel *viewModel = [[TCSGroupsViewModel alloc] initWithController:self.controller];
            return [RACSignal return:viewModel];
        }];

        _logInToFacebookCommand = [[RACCommand alloc] initWithEnabled:logInEnabled signalBlock:^RACSignal *(id _) {
            @strongify(self);
            return [self.controller logInToFacebook];
        }];

        _logOutOfFacebookCommand = [[RACCommand alloc] initWithEnabled:logOutEnabled signalBlock:^RACSignal *(id _) {
            @strongify(self);
            return [self.controller logOutOfFacebook];
        }];

        _reauthenticateFacebookCommand = [[RACCommand alloc] initWithEnabled:reauthenticateEnabled signalBlock:^RACSignal *(id _) {
            @strongify(self);
            return [self.controller reauthenticateFacebook];
        }];

        RAC(self, loading) =
            [[RACSignal merge:
                @[
                    [self.logInToFacebookCommand executing],
                    [self.logOutOfFacebookCommand executing],
                    [self.reauthenticateFacebookCommand executing]
                ]]
                or];

        [[[RACSignal merge:
            @[
                [self.logInToFacebookCommand errors],
                [self.logOutOfFacebookCommand errors],
                [self.reauthenticateFacebookCommand errors]
            ]]
            switchToLatest]
            subscribe:_errors];

        [[self.didBecomeActiveSignal
            flattenMap:^RACStream *(TCSLoginViewModel *loginViewModel) {
                return [[loginViewModel reauthenticateFacebookCommand] execute:nil];
            }]
            subscribeError:^(NSError *error) { }];
    }
    return self;
}

@end
