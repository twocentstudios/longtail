//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSGroupsViewModel.h"
#import "TCSViewModel+Protected.h"

#import "TCSPostController.h"

#import "TCSGroupViewModel.h"

#import "TCSGroupObject.h"

#pragma mark -

@interface TCSGroupsViewModel ()

@property (nonatomic) TCSPostController *controller;

@property (nonatomic) NSString *title;
@property (nonatomic) NSArray *groupViewModels;

@property (nonatomic) RACCommand *loadGroupsCommand;

@end

@implementation TCSGroupsViewModel

- (instancetype)initWithController:(TCSPostController *)controller {
    self = [super init];
    if (self != nil) {
        _controller = controller;

        @weakify(self);

        self.title = NSLocalizedString(@"Groups", nil);

        self.loadGroupsCommand =
            [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
                @strongify(self);
                return [self.controller getGroups];
            }];

        RAC(self, groupViewModels) =
            [[[[[self.loadGroupsCommand executionSignals]
                switchToLatest]
                map:^id(NSArray *groups) {
                    return [[groups.rac_sequence.signal
                                map:^id(TCSGroupObject *group) {
                                    return [[TCSGroupViewModel alloc] initWithGroup:group];
                                }]
                                toArray];
                }]
                map:^id(NSArray *posts) {
                    return [posts sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@keypath(TCSGroupObject.new, order) ascending:YES]]];
                }]
                deliverOn:[RACScheduler mainThreadScheduler]];

        [[[self.loadGroupsCommand errors]
            deliverOn:[RACScheduler mainThreadScheduler]]
            subscribe:_errors];

        [self.didBecomeActiveSignal subscribeNext:^(TCSGroupsViewModel *viewModel) {
            [viewModel.loadGroupsCommand execute:nil];
        }];
    }
    return self;
}

@end
