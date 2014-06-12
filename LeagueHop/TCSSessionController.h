//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

// Interfaces with the Facebook SDK to provide an open session.
@interface TCSSessionController : NSObject

// A replay subject that sends the current Facebook session and never completes.
@property (nonatomic, readonly) RACSignal *facebookSession;

// Sends the session then completes. Sends error if session is not in FBSessionCreated state.
- (RACSignal *)logInToFacebook;

// Sends the session then completes. Sends error if session is not in FBSessionCreatedTokenLoaded state.
- (RACSignal *)reauthenticateFacebook;

// Sends the session then completes.
- (RACSignal *)logOutOfFacebook;

@end
