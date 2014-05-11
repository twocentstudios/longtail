//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSPostViewModel.h"

#import "TCSPostObject.h"
#import "TCSUserObject.h"
#import "TCSCommentObject.h"

@interface TCSPostViewModel ()

@property (nonatomic) TCSPostObject *post;

@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *message;
@property (nonatomic) NSString *likesSummary;
@property (nonatomic) NSAttributedString *commentsSummary;

@end

#pragma mark -

@implementation TCSPostViewModel

- (instancetype)initWithPost:(TCSPostObject *)post {
    self = [super init];
    if (self != nil) {
        _post = post;

        RAC(self, userName) = RACObserve(self, post.user.userName);
        RAC(self, message) = RACObserve(self, post.message);
        RAC(self, likesSummary) =
            [RACObserve(self, post.likes) map:^id(NSArray *likes) {
                NSArray *likeNamesArray = [likes valueForKey:@"userName"];
                NSString *likeNames = [likeNamesArray componentsJoinedByString:@", "];
                return [NSString stringWithFormat:@"Likes: %@", likeNames];
            }];
        RAC(self, commentsSummary) =
            [RACObserve(self, post.comments) map:^id(NSArray *comments) {
                UIFont *font = [UIFont systemFontOfSize:14];
                UIFont *boldFont = [UIFont boldSystemFontOfSize:14];
                NSMutableAttributedString *allComments = [[NSMutableAttributedString alloc] init];
                NSAttributedString *spaceString = [[NSAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName: font}];
                NSAttributedString *newLineString = [[NSAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName: font}];
                for (TCSCommentObject *comment in comments) {
                    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:comment.user.userName attributes:@{NSFontAttributeName: boldFont, NSForegroundColorAttributeName: [UIColor blackColor]}];
                    NSAttributedString *commentString = [[NSAttributedString alloc] initWithString:comment.message attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor blackColor]}];
                    [allComments appendAttributedString:nameString];
                    [allComments appendAttributedString:[spaceString copy]];
                    [allComments appendAttributedString:commentString];
                    [allComments appendAttributedString:[newLineString copy]];
                }
                return [allComments copy];
            }];
    }
    return self;
}

@end
