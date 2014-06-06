//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSSessionController.h"

#import <FacebookSDK/FacebookSDK.h>

NSString * const kFacebookReadPermissions = @"public_profile,user_groups";

@interface TCSSessionController ()

@property (nonatomic) RACSignal *facebookSession;

@end

#pragma mark -

@implementation TCSSessionController

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _facebookSession =
            [[[[[RACSignal
                    merge:@[ [[NSNotificationCenter defaultCenter] rac_addObserverForName:FBSessionDidBecomeOpenActiveSessionNotification object:nil],
                             [[NSNotificationCenter defaultCenter] rac_addObserverForName:FBSessionDidBecomeClosedActiveSessionNotification object:nil] ]]
                    map:^FBSession *(NSNotification *notification) {
                        return (FBSession *)notification.object;
                    }]
                    startWith:[FBSession activeSession]]
                    multicast:[RACReplaySubject replaySubjectWithCapacity:1]]
                    autoconnect];
    }
    return self;
}

- (RACSignal *)logOutOfFacebook {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[FBSession activeSession] closeAndClearTokenInformation];
        [subscriber sendNext:[FBSession activeSession]];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)reauthenticateFacebook {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if ([FBSession activeSession].state != FBSessionStateCreatedTokenLoaded) {
            [subscriber sendError:[NSError errorWithDomain:@"com.twocentstudios.longtail" code:1 userInfo:@{NSLocalizedDescriptionKey: @"No cached Facebook token found."}]];
        } else {
            [FBSession openActiveSessionWithReadPermissions:[kFacebookReadPermissions componentsSeparatedByString:@","]
                                               allowLoginUI:NO
                                          completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                                if (error) {
                                                    [subscriber sendError:error];
                                                } else {
                                                    [subscriber sendNext:session];
                                                    [subscriber sendCompleted];
                                                }
                                            }];
        }
        return nil;
    }];
}

- (RACSignal *)logInToFacebook {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if ([FBSession activeSession].state != FBSessionStateCreated && !FB_ISSESSIONSTATETERMINAL([FBSession activeSession].state)) {
            [subscriber sendError:[NSError errorWithDomain:@"com.twocentstudios.longtail" code:1 userInfo:@{NSLocalizedDescriptionKey: @"Facebook session state not ready for log in."}]];
        } else {
            [FBSession openActiveSessionWithReadPermissions:[kFacebookReadPermissions componentsSeparatedByString:@","]
                                               allowLoginUI:YES
                                          completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                                if (error) {
                                                    [subscriber sendError:error];
                                                } else {
                                                    [subscriber sendNext:session];
                                                    [subscriber sendCompleted];
                                                }
                                            }];
        }
        return nil;
    }];
}

@end
