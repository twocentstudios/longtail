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

#import "TCSInformationViewModel.h"

@interface TCSGroupsViewModel ()

@property (nonatomic) TCSPostController *controller;

@property (nonatomic) NSString *title;
@property (nonatomic) NSArray *groupViewModels;
@property (nonatomic) TCSInformationViewModel *emptyViewModel;

@property (nonatomic) NSString *nextButtonTitle;
@property (nonatomic) RACCommand *nextCommand;

@property (nonatomic) RACCommand *loadGroupsCommand;
@property (nonatomic) RACCommand *confirmSelectionCommand;

@end

#pragma mark -

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

        RAC(self, nextCommand) =
            [RACObserve(self, groupViewModels)
                map:^RACCommand *(NSArray *groupViewModels) {
                    @strongify(self);
                    if ([groupViewModels count] > 0) {
                        return self.confirmSelectionCommand;
                    } else {
                        return self.loadGroupsCommand;
                    }
                }];

        RAC(self, nextButtonTitle) =
            [RACObserve(self, groupViewModels)
                map:^NSString *(NSArray *groupViewModels) {
                    if ([groupViewModels count] > 0) {
                        return NSLocalizedString(@"Import", nil);
                    } else {
                        return NSLocalizedString(@"Refresh", nil);
                    }
                }];

        RAC(self, groupViewModels) =
            [[[[[self.loadGroupsCommand executionSignals]
                switchToLatest]
                map:^id(NSArray *groups) {
                    return [groups sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@keypath(TCSGroupObject.new, order) ascending:YES]]];
                }]
                map:^NSArray *(NSArray *groups) {
                    return [[groups.rac_sequence.signal
                                map:^id(TCSGroupObject *group) {
                                    return [[TCSGroupViewModel alloc] initWithGroup:group];
                                }]
                                toArray];
                }]
                deliverOn:[RACScheduler mainThreadScheduler]];

        _emptyViewModel = [[TCSInformationViewModel alloc] initWithTitle:NSLocalizedString(@"You have no Facebook Groups", nil) subtitle:NSLocalizedString(@"Tap retry if you actually do have Facebook Groups.", nil)];

        RAC(self.emptyViewModel, hidden) =
            [RACSignal
                combineLatest:@[ RACObserve(self, groupViewModels),
                                 [self.loadGroupsCommand executing],
                                 RACObserve(self, active) ]
                reduce:^NSNumber *(NSArray *groupViewModels, NSNumber *executing, NSNumber *active) {
                    return @([groupViewModels count] > 0 || [executing boolValue] || ![active boolValue]);
                }];

        [[[RACSignal merge:@[
                            [self.loadGroupsCommand errors],
                            [self.confirmSelectionCommand errors] ]]
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
                    *errorPtr = [NSError errorWithDescription:@"At least one group must be selected."];
                    return nil;
                }]
                combineLatestWith:[RACSignal return:controller]]
                reduceEach:^id(NSArray *selectedGroups, TCSPostController *postController){
                    TCSGroupImportViewModel *importViewModel = [[TCSGroupImportViewModel alloc] initWithGroups:selectedGroups controller:postController];
                    return importViewModel;
                }];
}

@end
