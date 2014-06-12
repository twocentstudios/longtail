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
    RACSignal *signal =
        [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
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

    return [[self class] decodeFacebookErrorsOnSignal:signal];
}

- (RACSignal *)logInToFacebook {
    RACSignal *signal =
        [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
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

    return [[self class] decodeFacebookErrorsOnSignal:signal];
}

# pragma mark Private

+ (RACSignal *)decodeFacebookErrorsOnSignal:(RACSignal *)signal {
    return [[[signal
        materialize]
        map:^RACEvent *(RACEvent *event) {
            if (event.eventType == RACEventTypeError) {
                NSError *inputError = event.error;
                NSString *outputDescription;

                if ([FBErrorUtility shouldNotifyUserForError:inputError] == YES){
                    // Error requires people using you app to make an action outside your app to recover
                    outputDescription = [FBErrorUtility userMessageForError:inputError];
                } else {
                    if ([FBErrorUtility errorCategoryForError:inputError] == FBErrorCategoryUserCancelled) {
                        outputDescription = @"You need to login to access this part of the app";
                    } else if ([FBErrorUtility errorCategoryForError:inputError] == FBErrorCategoryAuthenticationReopenSession){
                        // We need to handle session closures that happen outside of the app
                        outputDescription = @"Your current session is no longer valid. Please log in again.";
                    } else {
                        outputDescription = @"Something's up with Facebook. Please try again.";
                    }
                }

                NSError *outputError = [NSError errorWithDomain:@"com.twocentstudios.longtail" code:1 userInfo:@{NSLocalizedDescriptionKey: outputDescription}];
                return [RACEvent eventWithError:outputError];
            } else {
                return event;
            }
        }]
        dematerialize];
}

@end
