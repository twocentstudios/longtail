//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSGroupImportViewModel.h"
#import "TCSViewModel+Protected.h"

#import "TCSPostController.h"

@interface TCSGroupImportViewModel ()

@property (nonatomic) NSString *title;
@property (nonatomic) NSArray *groups;

@property (nonatomic) RACCommand *importCommand;
@property (nonatomic) RACSignal *importedPostsCountsSignal;

@property (nonatomic) TCSPostController *controller;

@end

#pragma mark -

@implementation TCSGroupImportViewModel

- (instancetype)initWithGroups:(NSArray *)groups controller:(TCSPostController *)controller {
    NSParameterAssert(groups);
    NSParameterAssert(controller);

    self = [super init];
    if (self != nil) {
        _groups = groups;
        _controller = controller;

        _title = NSLocalizedString(@"Importing posts...", nil);

        @weakify(self);

        _importCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            @strongify(self);
            return [self.controller importPostsForGroups:self.groups];
        }];

        _importedPostsCountsSignal =
            [[[[[_importCommand executionSignals]
                take:1]
                flatten]
                map:^NSString *(NSNumber *postsCount) {
                    return [postsCount stringValue];
                }]
                deliverOn:[RACScheduler mainThreadScheduler]];

        [self.didBecomeActiveSignal subscribeNext:^(TCSGroupImportViewModel *viewModel) {
            [viewModel.importCommand execute:nil];
        }];
    }
    return self;
}

@end
