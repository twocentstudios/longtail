//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSGroupImportViewController.h"


#pragma mark -

@interface TCSGroupImportViewController ()

@end


@implementation TCSGroupImportViewController

@dynamic viewModel;

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    @weakify(self);

    RAC(self, title) = RACObserve(self, viewModel.title);

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@keypath(CALayer.new, backgroundColor)];
    [animation setFromValue:(id)[UIColor whiteColor].CGColor];
    [animation setToValue:(id)[UIColor blueColor].CGColor];
    [animation setDuration:3.0];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:CGFLOAT_MAX];

    [[[[RACObserve(self, viewModel.importCommand.executing)
        flatten]
        ignore:nil]
        distinctUntilChanged]
        subscribeNext:^(NSNumber *executing) {
            @strongify(self);
            if ([executing boolValue]) {
                [self.view.layer addAnimation:animation forKey:@"background"];
            } else {
                [self.view.layer removeAnimationForKey:@"background"];
            }
        }];

    [[RACObserve(self, viewModel.importedPostsCountsSignal) logAll]
        subscribeCompleted:^{
            @strongify(self);
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
}

@end