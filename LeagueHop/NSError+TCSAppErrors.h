//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

// Convenience methods for creating and transforming errors.
@interface NSError (TCSAppErrors)

// A generic error.
+ (NSError *)errorWithDescription:(NSString *)description;

// Transform a Facebook error into a descriptive error in the app domain.
+ (NSError *)errorForFacebookError:(NSError *)facebookError;

@end
