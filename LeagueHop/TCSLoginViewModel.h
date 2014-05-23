//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewModel.h"

@class TCSPostController;

#pragma mark -

@interface TCSLoginViewModel : TCSViewModel

@property (nonatomic, readonly) NSString *loginButtonText;

@property (nonatomic, readonly, getter = isLoading) BOOL loading;

@property (nonatomic, readonly) RACCommand *logInToFacebookCommand;
@property (nonatomic, readonly) RACCommand *logOutOfFacebookCommand;
@property (nonatomic, readonly) RACCommand *confirmFacebookUserCommand;

- (instancetype)initWithController:(TCSPostController *)controller;

@end
