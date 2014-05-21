//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSGroupsViewModel.h"
#import "TCSViewModel+Protected.h"

#import "TCSPostController.h"

#import "TCSGroupViewModel.h"
#import "TCSGroupImportViewModel.h"

#import "TCSGroupObject.h"

#pragma mark -

@interface TCSGroupsViewModel ()

@property (nonatomic) TCSPostController *controller;

@property (nonatomic) NSString *title;
@property (nonatomic) NSArray *groupViewModels;

@property (nonatomic) RACCommand *loadGroupsCommand;
@property (nonatomic) RACCommand *confirmSelectionCommand;

@end

@implementation TCSGroupsViewModel

- (instancetype)initWithController:(TCSPostController *)controller {
    self = [super init];
    if (self != nil) {
        _controller = controller;

        @weakify(self);

        self.title = NSLocalizedString(@"Select Groups", nil);

        self.loadGroupsCommand =
            [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
                @strongify(self);
                return [self.controller getGroups];
            }];

        self.confirmSelectionCommand =
            [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
                @strongify(self);
                return importViewModelSignal(self.groupViewModels, self.controller);
            }];

        RAC(self, groupViewModels) =
            [[[[[self.loadGroupsCommand executionSignals]
                switchToLatest]
                map:^id(NSArray *groups) {
                    return [groups sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@keypath(TCSGroupObject.new, order) ascending:YES]]];
                }]
                map:^id(NSArray *groups) {
                    return [[groups.rac_sequence.signal
                                map:^id(TCSGroupObject *group) {
                                    return [[TCSGroupViewModel alloc] initWithGroup:group];
                                }]
                                toArray];
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

// Sends a new TCSGroupImportViewModel initialized with an array of TCSGroupObjects and a controller
RACSignal *importViewModelSignal(NSArray *groupViewModels, TCSPostController *controller) {
    return [[[[[RACSignal return:groupViewModels]
                map:^NSArray *(NSArray *groupViewModels) {
                    return [groupViewModels filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K = YES", @keypath(TCSGroupViewModel.new, selected)]];
                }]
                tryMap:^NSArray *(NSArray *selectedGroupViewModels, NSError *__autoreleasing *errorPtr) {
                    if ([selectedGroupViewModels count] > 0) {
                        return [selectedGroupViewModels valueForKey:@keypath(TCSGroupViewModel.new, group)];
                    }
                    *errorPtr = [NSError errorWithDomain:@"com.twocentstudios.leaguehop" code:1 userInfo:@{NSLocalizedDescriptionKey: @"At least one group must be selected."}];
                    return nil;
                }]
                combineLatestWith:[RACSignal return:controller]]
                reduceEach:^id(NSArray *selectedGroups, TCSPostController *postController){
                    TCSGroupImportViewModel *importViewModel = [[TCSGroupImportViewModel alloc] initWithGroup:selectedGroups controller:postController];
                    return importViewModel;
                }];
}

@end
