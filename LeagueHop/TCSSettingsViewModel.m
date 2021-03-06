//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSSettingsViewModel.h"
#import "TCSViewModel+Protected.h"

#import "TCSSessionController.h"
#import "TCSPostController.h"

#import "TCSGroupsViewModel.h"
#import "TCSWebViewModel.h"

#import <FacebookSDK/FacebookSDK.h>

@interface TCSSettingsViewModel ()

@property (nonatomic) NSString *title;

@property (nonatomic) NSString *importGroupsButtonText;
@property (nonatomic) NSString *logInOutButtonText;
@property (nonatomic) NSString *importGroupsHintText;
@property (nonatomic) NSString *authorText;
@property (nonatomic) NSString *licensesText;

@property (nonatomic, getter = isLoading) BOOL loading;

@property (nonatomic) RACCommand *logInOutFacebookCommand;
@property (nonatomic) RACCommand *presentGroupImportCommand;
@property (nonatomic) RACCommand *deleteAllCommand;
@property (nonatomic) RACCommand *presentAuthorCommand;
@property (nonatomic) RACCommand *presentLicensesCommand;

@property (nonatomic) TCSSessionController *sessionController;
@property (nonatomic) TCSPostController *postController;

@end

#pragma mark -

@implementation TCSSettingsViewModel

- (instancetype)initWithSessionController:(TCSSessionController *)sessionController postController:(TCSPostController *)postController {
    NSParameterAssert(sessionController);
    NSParameterAssert(postController);

    self = [super init];
    if (self != nil) {
        _sessionController = sessionController;
        _postController = postController;

        @weakify(self);

        self.title = NSLocalizedString(@"Settings", nil);

        RAC(self, logInOutButtonText) =
            [[self.sessionController facebookSession]
                map:^NSString *(FBSession *session) {
                    if (session.state == FBSessionStateCreated || session.state == FBSessionStateCreatedTokenLoaded || FB_ISSESSIONSTATETERMINAL(session.state)) {
                        return NSLocalizedString(@"Log in with Facebook", nil);
                    } else if (session.state == FBSessionStateCreatedOpening) {
                        return NSLocalizedString(@"Logging in...", nil);
                    } else if (FB_ISSESSIONOPENWITHSTATE(session.state)) {
                        return NSLocalizedString(@"Log out of Facebook", nil);
                    } else {
                        return @"Error";
                    }
                }];

        RACSignal *logOutEnabled =
            [[self.sessionController facebookSession]
                map:^NSNumber *(FBSession *session) {
                    if (session.state == FBSessionStateOpen || session.state == FBSessionStateOpenTokenExtended) {
                        return @YES;
                    } else {
                        return @NO;
                    }
                }];

        RAC(self, importGroupsButtonText) =
            [logOutEnabled map:^NSString *(NSNumber *logOutEnabled) {
                if ([logOutEnabled boolValue]) {
                    return NSLocalizedString(@"Import Facebook Groups", nil);
                } else {
                    return NSLocalizedString(@"Import Facebook Groups", nil);
                }
            }];

        RAC(self, importGroupsHintText) =
            [logOutEnabled map:^NSString *(NSNumber *logOutEnabled) {
                if ([logOutEnabled boolValue]) {
                    return NSLocalizedString(@"We'll show you posts from your Facebook Groups this day in past years.", nil);
                } else {
                    return NSLocalizedString(@"Please log in to Facebook first before importing your Facebook Groups", nil);
                }
            }];

        _presentGroupImportCommand = [[RACCommand alloc] initWithEnabled:logOutEnabled signalBlock:^RACSignal *(id _) {
            @strongify(self);
            TCSGroupsViewModel *viewModel = [[TCSGroupsViewModel alloc] initWithController:self.postController];
            return [RACSignal return:viewModel];
        }];

        _logInOutFacebookCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            @strongify(self);
            return [[[self.sessionController facebookSession]
                        take:1]
                        flattenMap:^RACSignal *(FBSession *session) {
                            if (session.state == FBSessionStateCreated || FB_ISSESSIONSTATETERMINAL(session.state)) {
                                return [self.sessionController logInToFacebook];
                            } else if (session.state == FBSessionStateCreatedTokenLoaded) {
                                return [self.sessionController reauthenticateFacebook];
                            } else if (FB_ISSESSIONOPENWITHSTATE(session.state)) {
                                return [self.sessionController logOutOfFacebook];
                            } else {
                                return [RACSignal empty];
                            }
                        }];
        }];

        _deleteAllCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            @strongify(self);
            return [[self.postController removeAllObjects] delay:2]; // Add some artificial delay so the user can see what's happening
        }];

        RAC(self, deleteAllButtonText) =
            [[_deleteAllCommand executing]
                map:^NSString *(NSNumber *executing) {
                    return [executing boolValue] ? NSLocalizedString(@"Deleting...", nil) : NSLocalizedString(@"Delete All Posts", nil);
                }];

        _presentAuthorCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            NSURL *URL = [NSURL URLWithString:@"http://twitter.com/twocentstudios"];
            TCSWebViewModel *viewModel = [[TCSWebViewModel alloc] initWithURL:URL title:NSLocalizedString(@"Twitter", nil)];
            return [RACSignal return:viewModel];
        }];

        _presentLicensesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            NSURL *URL = [NSURL URLWithString:@"http://twocentstudios.com/apps/longtail/licenses.html"];
            TCSWebViewModel *viewModel = [[TCSWebViewModel alloc] initWithURL:URL title:NSLocalizedString(@"Licenses", nil)];
            return [RACSignal return:viewModel];
        }];

        _authorText = NSLocalizedString(@"@twocentstudios", nil);
        _licensesText = NSLocalizedString(@"Licenses", nil);

        RAC(self, loading) =
            [[RACSignal combineLatest:@[
                    [self.logInOutFacebookCommand executing],
                    [self.deleteAllCommand executing]
                ]]
                or];

        [[self.logInOutFacebookCommand errors] subscribe:_errors];
    }
    return self;
}

@end
