//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSPostCell.h"

#import "TCSPostViewModel.h"

#pragma mark -

@implementation TCSPostCell

#pragma mark Creation

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        RAC(self.textLabel, text) = RACObserve(self, viewModel.message);
    }
    return self;
}

@end
