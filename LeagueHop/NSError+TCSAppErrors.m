//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "NSError+TCSAppErrors.h"

#import <FacebookSDK/FacebookSDK.h>

#pragma mark -

@implementation NSError (TCSAppErrors)

+ (NSError *)errorForFacebookError:(NSError *)facebookError {
    NSString *outputDescription;
    NSError *innerError = [facebookError userInfo][FBErrorInnerErrorKey];

    if ([FBErrorUtility shouldNotifyUserForError:facebookError] == YES){
        // Error requires people using you app to make an action outside your app to recover
        outputDescription = [FBErrorUtility userMessageForError:facebookError];
    } else if ([FBErrorUtility errorCategoryForError:facebookError] == FBErrorCategoryUserCancelled) {
        outputDescription = @"You need to login to access this part of the app";
    } else if ([FBErrorUtility errorCategoryForError:facebookError] == FBErrorCategoryAuthenticationReopenSession){
        // We need to handle session closures that happen outside of the app
        outputDescription = @"Your current session is no longer valid. Please log in again.";
    } else if (innerError != nil) {
        outputDescription = [innerError localizedDescription];
    } else {
        outputDescription = @"Something's up with Facebook. Please try again.";
    }

    NSError *outputError = [NSError errorWithDescription:outputDescription];
    return outputError;
}

+ (NSError *)errorWithDescription:(NSString *)description {
    return [NSError errorWithDomain:@"com.twocentstudios.longtail" code:1 userInfo:@{NSLocalizedDescriptionKey: description ?: @"An error occurred."}];
}

@end
