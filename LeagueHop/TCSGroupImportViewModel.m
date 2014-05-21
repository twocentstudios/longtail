//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSGroupImportViewModel.h"
#import "TCSViewModel+Protected.h"

#import "TCSPostController.h"

#pragma mark -

@interface TCSGroupImportViewModel ()


@property (nonatomic) NSString *title;
@property (nonatomic) NSArray *groups;

@property (nonatomic) RACCommand *importCommand;
@property (nonatomic) RACSignal *importedPostsCountsSignal;

@property (nonatomic) TCSPostController *controller;

@end

@implementation TCSGroupImportViewModel

- (instancetype)initWithGroup:(NSArray *)groups controller:(TCSPostController *)controller {
    NSParameterAssert(groups);
    NSParameterAssert(controller);

    self = [super init];
    if (self != nil) {
        _groups = groups;
        _controller = controller;

        _title = NSLocalizedString(@"Importing...", nil);

        @weakify(self);

        _importCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            @strongify(self);
            return [self.controller importPostsForGroups:self.groups];
        }];

        _importedPostsCountsSignal =
            [[[[_importCommand executionSignals]
                take:1]
                flatten]
                map:^NSString *(NSNumber *postsCount) {
                    return [postsCount stringValue];
                }];

        [self.didBecomeActiveSignal subscribeNext:^(TCSGroupImportViewModel *viewModel) {
            [viewModel.importCommand execute:nil];
        }];
    }
    return self;
}

@end
