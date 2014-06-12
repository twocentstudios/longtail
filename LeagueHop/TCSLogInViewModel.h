//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSViewModel.h"

@class TCSSessionController;
@class TCSPostController;
@class TCSGroupsViewModel;

@interface TCSLogInViewModel : TCSViewModel

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *subtitle;

@property (nonatomic, readonly) NSString *logInButtonText;

@property (nonatomic, readonly) RACCommand *logInFacebookCommand;

// Stores a groupsViewModel that should be presented whenever this property is non-nil
@property (nonatomic, readonly) TCSGroupsViewModel *groupsViewModel;

- (instancetype)initWithSessionController:(TCSSessionController *)sessionController postController:(TCSPostController *)postController;

@end
