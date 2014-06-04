//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSPostsViewModel.h"
#import "TCSViewModel+Protected.h"

#import "TCSPostController.h"
#import "TCSPostViewModel.h"
#import "TCSPostObject.h"

#import "TCSSettingsViewModel.h"
#import "TCSSessionController.h"

#import "TCSLogInViewModel.h"
#import "TCSLogInViewController.h"

#import "TCSWebViewModel.h"

#import "NSDate+TCSDateKey.h"

@interface TCSPostsViewModel ()

@property (nonatomic) TCSPostController *controller;

@property (nonatomic) NSString *title;
@property (nonatomic) NSArray *postViewModels;

@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *monthDayKey;

@property (nonatomic) RACCommand *loadPostsCommand;
@property (nonatomic) RACCommand *presentSettingsCommand;
@property (nonatomic) RACSignal *shouldPresentLogInSignal;
@property (nonatomic) RACCommand *openURLCommand;

@end

#pragma mark -

@implementation TCSPostsViewModel

- (instancetype)initWithController:(TCSPostController *)controller {
    self = [super init];
    if (self != nil) {
        _controller = controller;

        @weakify(self);

        RAC(self, date) = [[RACSignal interval:5*60 onScheduler:[RACScheduler mainThreadScheduler]] startWith:[NSDate date]];
//        self.date = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*42];
        RAC(self, title) =
            [[RACObserve(self, date) map:^id(NSDate *date) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateStyle:NSDateFormatterLongStyle];
                return [dateFormatter stringFromDate:date];
            }]
            distinctUntilChanged];

        RAC(self, monthDayKey) =
            [[RACObserve(self, date) map:^id(NSDate *date) {
                return [date monthDayDateKey];
            }]
            distinctUntilChanged];

        _loadPostsCommand =
            [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
                @strongify(self);
                return [self.controller queryPostsForMonthDayKey:self.monthDayKey];
            }];

        _presentSettingsCommand =
            [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    @strongify(self);
                    TCSSessionController *sessionController = [[TCSSessionController alloc] init];
                    TCSSettingsViewModel *settingsViewModel = [[TCSSettingsViewModel alloc] initWithSessionController:sessionController postController:self.controller];
                    [subscriber sendNext:settingsViewModel];
                    [subscriber sendCompleted];
                    return nil;
                }];
            }];

        _openURLCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSURL *URL) {
            TCSWebViewModel *webViewModel = [[TCSWebViewModel alloc] initWithURL:URL title:nil];
            return [RACSignal return:webViewModel];
        }];

        RAC(self, postViewModels) =
            [[[[[self.loadPostsCommand executionSignals]
                switchToLatest]
                map:^id(NSArray *posts) {
                    return [posts sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@keypath(TCSPostObject.new, createdAt) ascending:NO]]];
                }]
                map:^id(NSArray *posts) {
                    return [[posts.rac_sequence.signal
                                map:^id(TCSPostObject *post) {
                                    @strongify(self);
                                    return [[TCSPostViewModel alloc] initWithPost:post openURLCommand:self.openURLCommand];
                                }]
                                toArray];
                }]
                deliverOn:[RACScheduler mainThreadScheduler]];

        [[[self.loadPostsCommand errors]
            deliverOn:[RACScheduler mainThreadScheduler]]
            subscribe:_errors];

        [self.didBecomeActiveSignal subscribeNext:^(TCSPostsViewModel *viewModel) {
            [viewModel.loadPostsCommand execute:nil];
        }];

        _shouldPresentLogInSignal =
            [[[self.didBecomeActiveSignal
                flattenMap:^RACSignal *(TCSPostsViewModel *viewModel) {
                    return [viewModel.controller isImportNeeded];
                }]
                filter:^BOOL(NSNumber *isImportNeeded) {
                    return [isImportNeeded boolValue];
                }]
                map:^TCSLogInViewModel *(id _) {
                    @strongify(self);
                    TCSSessionController *sessionController = [[TCSSessionController alloc] init];
                    TCSLogInViewModel *viewModel = [[TCSLogInViewModel alloc] initWithSessionController:sessionController postController:self.controller];
                    return viewModel;
                }];

    }
    return self;
}

@end
