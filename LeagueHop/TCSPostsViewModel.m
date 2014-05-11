//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSPostsViewModel.h"
#import "TCSViewModel+Protected.h"

#import "TCSPostController.h"
#import "TCSPostViewModel.h"
#import "TCSPostObject.h"

#import "NSDate+TCSDateKey.h"

@interface TCSPostsViewModel ()

@property (nonatomic) TCSPostController *controller;

@property (nonatomic) NSString *title;
@property (nonatomic) NSArray *postViewModels;

@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *monthDayKey;

@property (nonatomic) RACCommand *loadPostsCommand;

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
                return [self.controller fetchPostsForMonthDayKey:self.monthDayKey];
            }];

        RAC(self, postViewModels) =
            [[[[self.loadPostsCommand executionSignals]
                switchToLatest]
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
    }
    return self;
}

@end
