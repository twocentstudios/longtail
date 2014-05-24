//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewModel.h"

@class TCSSessionController;

#pragma mark -

@interface TCSLoginViewModel : TCSViewModel

@property (nonatomic, readonly) NSString *title;

@property (nonatomic, readonly) NSString *importGroupsButtonText;
@property (nonatomic, readonly) NSString *logInOutButtonText;

@property (nonatomic, readonly, getter = isLoading) BOOL loading;

@property (nonatomic, readonly) RACCommand *logInOutFacebookCommand;
@property (nonatomic, readonly) RACCommand *presentGroupImportCommand;

- (instancetype)initWithController:(TCSSessionController *)controller;

@end
