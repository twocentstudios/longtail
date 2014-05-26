//
//  TCSStyle.h
//  LeagueHop
//
//  Created by Chris Trott on 5/25/14.
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#ifndef LeagueHop_TCSStyle_h
#define LeagueHop_TCSStyle_h

// Color picking helpers
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define GRAYCOLOR(g) [UIColor colorWithRed:(g)/255.0f green:(g)/255.0f blue:(g)/255.0f alpha:1]
#define GRAYACOLOR(g,a) [UIColor colorWithRed:(g)/255.0f green:(g)/255.0f blue:(g)/255.0f alpha:(a)]
#define COLORA(c,a) [c colorWithAlphaComponent:a]

// Application Constant Colors
#define CLEAR GRAYACOLOR(255, 0)
#define BLACK GRAYCOLOR(0)
#define WHITE GRAYCOLOR(255)
#define BLACKA(a) GRAYACOLOR(0, a)
#define WHITEA(a) GRAYACOLOR(255, a)

#define GRAY_BLACK GRAYCOLOR(30)
#define GRAY_DARK GRAYCOLOR(78)
#define GRAY_MEDIUM GRAYCOLOR(140)
#define GRAY_LIGHT GRAYCOLOR(184)
#define GRAY_WHITE GRAYCOLOR(240)
#define GRAY_PATTERN [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-table"]]

// Application Fonts
#define FONT_REGULAR(s) [UIFont fontWithName:@"AvenirNext-Regular" size:(s)]
#define FONT_MEDIUM(s) [UIFont fontWithName:@"AvenirNext-Medium" size:(s)]
#define FONT_LIGHT(s) [UIFont fontWithName:@"AvenirNext-UltraLight" size:(s)]
#define FONT_DEMIBOLD(s) [UIFont fontWithName:@"AvenirNext-DemiBold" size:(s)]

#endif
