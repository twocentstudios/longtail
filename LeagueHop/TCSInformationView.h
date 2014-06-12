//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

@class TCSInformationViewModel;

// Shows a centered title/subtitle pair. Usually used for persistent empty/error states.
@interface TCSInformationView : UIView

- (instancetype)initWithViewModel:(TCSInformationViewModel *)viewModel;

@end
