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

@property (nonatomic) NSString *logInOutButtonText;

@property (nonatomic, getter = isLoading) BOOL loading;

@property (nonatomic) RACCommand *logInOutFacebookCommand;
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

        RAC(self, logInOutButtonText) =
            [[TCSPostController facebookSession]
                map:^NSString *(FBSession *session) {
                    if (session.state == FBSessionStateCreated || session.state == FBSessionStateCreatedTokenLoaded || FB_ISSESSIONSTATETERMINAL(session.state)) {
                        return NSLocalizedString(@"Log in with Facebook", nil);
                    } else if (session.state == FBSessionStateCreatedOpening) {
                        return NSLocalizedString(@"Logging in...", nil);
                    } else if (FB_ISSESSIONOPENWITHSTATE(session.state)) {
                        return NSLocalizedString(@"Log out", nil);
                    } else {
                        return @"Error";
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

        _confirmFacebookUserCommand = [[RACCommand alloc] initWithEnabled:logOutEnabled signalBlock:^RACSignal *(id _) {
            @strongify(self);
            TCSGroupsViewModel *viewModel = [[TCSGroupsViewModel alloc] initWithController:self.controller];
            return [RACSignal return:viewModel];
        }];

        _logInOutFacebookCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            @strongify(self);
            return [[[TCSPostController facebookSession]
                        take:1]
                        flattenMap:^RACSignal *(FBSession *session) {
                            if (session.state == FBSessionStateCreated || FB_ISSESSIONSTATETERMINAL(session.state)) {
                                return [self.controller logInToFacebook];
                            } else if (session.state == FBSessionStateCreatedTokenLoaded) {
                                return [self.controller reauthenticateFacebook];
                            } else if (FB_ISSESSIONOPENWITHSTATE(session.state)) {
                                return [self.controller logOutOfFacebook];
                            } else {
                                return [RACSignal empty];
                            }
                        }];
        }];

        RAC(self, loading) = [self.logInOutFacebookCommand executing];

        [[self.logInOutFacebookCommand errors] subscribe:_errors];
    }
    return self;
}

@end
