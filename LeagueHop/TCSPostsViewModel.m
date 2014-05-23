//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSPostsViewModel.h"
#import "TCSViewModel+Protected.h"

#import "TCSPostController.h"
#import "TCSPostViewModel.h"
#import "TCSPostObject.h"

#import "TCSLoginViewModel.h"

#import "NSDate+TCSDateKey.h"

@interface TCSPostsViewModel ()

@property (nonatomic) TCSPostController *controller;

@property (nonatomic) NSString *title;
@property (nonatomic) NSArray *postViewModels;

@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *monthDayKey;

@property (nonatomic) RACCommand *loadPostsCommand;
@property (nonatomic) RACSignal *presentLoginSignal;

@end

#pragma mark -

@implementation TCSPostsViewModel

- (instancetype)initWithController:(TCSPostController *)controller {
    self = [super init];
    if (self != nil) {
        _controller = controller;

        @weakify(self);

        RAC(self, date) = [[RACSignal interval:5*60 onScheduler:[RACScheduler mainThreadScheduler]] startWith:[NSDate date]];
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

        self.loadPostsCommand =
            [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
                @strongify(self);
                return [self.controller queryPostsForMonthDayKey:self.monthDayKey];
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
                                    return [[TCSPostViewModel alloc] initWithPost:post];
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

        _presentLoginSignal =
            [[[[self.didBecomeActiveSignal
                flattenMap:^RACSignal *(TCSPostsViewModel *viewModel) {
                    return [viewModel.controller isImportNeeded];
                }]
                filter:^BOOL(NSNumber *isImportNeeded) {
                    return [isImportNeeded boolValue];
                }]
                mapReplace:self.controller]
                map:^id(TCSPostController *controller) {
                    TCSLoginViewModel *loginViewModel = [[TCSLoginViewModel alloc] initWithController:controller];
                    return loginViewModel;
                }];

    }
    return self;
}

@end
