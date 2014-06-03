//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSGroupCell.h"

#import "TCSGroupViewModel.h"

#pragma mark -

@implementation TCSGroupCell

#pragma mark Creation

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        self.textLabel.font = FONT_MEDIUM(18);
        self.textLabel.textColor = GRAY_DARK;
        RAC(self.textLabel, text) = RACObserve(self, viewModel.name);
        RAC(self, accessoryType) =
            [RACObserve(self, viewModel.selected) map:^NSNumber *(NSNumber *selected) {
                return [selected boolValue] ? @(UITableViewCellAccessoryCheckmark) : @(UITableViewCellAccessoryNone);
            }];
    }
    return self;
}

@end
