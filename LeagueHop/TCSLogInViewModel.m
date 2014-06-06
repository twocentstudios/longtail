//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSLogInViewModel.h"
#import "TCSViewModel+Protected.h"

#import "TCSSessionController.h"
#import "TCSPostController.h"

#import <FacebookSDK/FacebookSDK.h>

#import "TCSGroupsViewModel.h"

@interface TCSLogInViewModel ()

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;

@property (nonatomic) NSString *logInButtonText;

@property (nonatomic) RACCommand *logInFacebookCommand;

@property (nonatomic) TCSGroupsViewModel *groupsViewModel;

@property (nonatomic) TCSSessionController *sessionController;
@property (nonatomic) TCSPostController *postController;

@end

#pragma mark -

@implementation TCSLogInViewModel

- (instancetype)initWithSessionController:(TCSSessionController *)sessionController postController:(TCSPostController *)postController {
    NSParameterAssert(sessionController);
    NSParameterAssert(postController);

    self = [super init];
    if (self != nil) {
        _sessionController = sessionController;
        _postController = postController;

        @weakify(self);

        _title = NSLocalizedString(@"Welcome to longtail", nil);
        _subtitle = NSLocalizedString(@"We'll show you what your Facebook Groups were talking about last year.", nil);

        RAC(self, logInButtonText) =
            [[self.sessionController facebookSession]
                map:^NSString *(FBSession *session) {
                    if (session.state == FBSessionStateCreated || session.state == FBSessionStateCreatedTokenLoaded || FB_ISSESSIONSTATETERMINAL(session.state)) {
                        return NSLocalizedString(@"Log in with Facebook", nil);
                    } else if (session.state == FBSessionStateCreatedOpening) {
                        return NSLocalizedString(@"Logging in...", nil);
                    } else if (FB_ISSESSIONOPENWITHSTATE(session.state)) {
                        return NSLocalizedString(@"Logged in successfully", nil);
                    } else {
                        return @"Error";
                    }
                }];

        RAC(self, groupsViewModel) =
            [[[self.sessionController facebookSession]
                distinctUntilChanged]
                map:^TCSGroupsViewModel *(FBSession *session) {
                    if (FB_ISSESSIONOPENWITHSTATE(session.state)) {
                        @strongify(self);
                        TCSGroupsViewModel *viewModel = [[TCSGroupsViewModel alloc] initWithController:self.postController];
                        return viewModel;
                    }
                    return nil;
                }];

        RACSignal *loginEnabled =
            [[self.sessionController facebookSession]
                map:^NSNumber *(FBSession *session) {
                    return @(!FB_ISSESSIONOPENWITHSTATE(session.state));
                }];

        _logInFacebookCommand = [[RACCommand alloc] initWithEnabled:loginEnabled signalBlock:^RACSignal *(id _) {
            @strongify(self);
            return [[[self.sessionController facebookSession]
                        take:1]
                        flattenMap:^RACSignal *(FBSession *session) {
                            if (session.state == FBSessionStateCreated || FB_ISSESSIONSTATETERMINAL(session.state)) {
                                return [self.sessionController logInToFacebook];
                            } else if (session.state == FBSessionStateCreatedTokenLoaded) {
                                return [self.sessionController reauthenticateFacebook];
                            } else {
                                return [RACSignal empty];
                            }
                        }];
        }];
    }

    return self;
}

@end
