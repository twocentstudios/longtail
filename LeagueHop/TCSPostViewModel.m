//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSPostViewModel.h"

#import "TCSPostObject.h"
#import "TCSUserObject.h"
#import "TCSCommentObject.h"
#import "UIColor+TCSColorId.h"

@interface TCSPostViewModel ()

@property (nonatomic) TCSPostObject *post;

@property (nonatomic) NSAttributedString *userName;
@property (nonatomic) NSAttributedString *postSummary;
@property (nonatomic) NSAttributedString *year;
@property (nonatomic) NSAttributedString *message;
@property (nonatomic) UIImage *linkImage;
@property (nonatomic) NSAttributedString *linkName;
@property (nonatomic) NSAttributedString *likesSummary;
@property (nonatomic) NSAttributedString *commentsSummary;

@end

#pragma mark -

@implementation TCSPostViewModel

- (instancetype)initWithPost:(TCSPostObject *)post {
    self = [super init];
    if (self != nil) {
        _post = post;

        RAC(self, userName) =
            [[RACObserve(self, post.user) ignore:nil] map:^NSAttributedString *(TCSUserObject *user) {
                return [[NSAttributedString alloc] initWithString:user.userName attributes:@{NSFontAttributeName: FONT_MEDIUM(12), NSForegroundColorAttributeName: [UIColor brightColorForNumber:@([user.userId integerValue])]}];
            }];

        RAC(self, postSummary) =
            [[RACObserve(self, post) ignore:nil] map:^NSAttributedString *(TCSPostObject *post) {
                NSMutableAttributedString *summary = [[NSMutableAttributedString alloc] init];
                NSDictionary *lightAttributes = @{NSFontAttributeName: FONT_LIGHT(9), NSForegroundColorAttributeName: GRAY_MEDIUM};
                NSDictionary *boldAttributes = @{NSFontAttributeName: FONT_MEDIUM(9), NSForegroundColorAttributeName: GRAY_MEDIUM};
                [summary appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"posted a ", nil) attributes:lightAttributes]];
                [summary appendAttributedString:[[NSAttributedString alloc] initWithString:post.type attributes:boldAttributes]];
                [summary appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@" in ", nil) attributes:lightAttributes]];
                [summary appendAttributedString:[[NSAttributedString alloc] initWithString:post.sourceObject.sourceName attributes:boldAttributes]];
                return [summary copy];
            }];

        RAC(self, message) =
            [[RACObserve(self, post.message) ignore:nil] map:^NSAttributedString *(NSString *message) {
                return [[NSAttributedString alloc] initWithString:message attributes:@{NSFontAttributeName: FONT_MEDIUM(18), NSForegroundColorAttributeName: GRAY_BLACK}];
            }];

        RAC(self, year) =
            [[RACObserve(self, post.createdAt) ignore:nil] map:^NSAttributedString *(NSDate *date) {
                static NSDateFormatter *dateFormatter;
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    dateFormatter = [[NSDateFormatter alloc] init];
                    dateFormatter.dateFormat = @"YYYY";
                });
                NSString *dateString = [dateFormatter stringFromDate:date];
                return [[NSAttributedString alloc] initWithString:dateString attributes:@{NSFontAttributeName: FONT_MEDIUM(12), NSForegroundColorAttributeName: GRAY_DARK}];
            }];

        RAC(self, linkName) =
            [[RACObserve(self, post.linkName) ignore:nil] map:^NSAttributedString *(NSString *linkName) {
                return [[NSAttributedString alloc] initWithString:linkName attributes:@{NSFontAttributeName: FONT_REGULAR(12), NSForegroundColorAttributeName: GRAY_DARK}];
            }];

        // RAC(self, linkImage) =  // TODO: Image fetching

        RAC(self, likesSummary) =
            [[RACObserve(self, post.likes) ignore:nil] map:^id(NSArray *likes) {
                NSMutableAttributedString *allLikes = [[NSMutableAttributedString alloc] init];
                NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Likes: ", nil) attributes:@{NSFontAttributeName: FONT_DEMIBOLD(10), NSForegroundColorAttributeName: GRAY_BLACK}];
                [allLikes appendAttributedString:titleString];
                for (TCSUserObject *user in likes) {
                    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:user.userName attributes:@{NSFontAttributeName: FONT_REGULAR(10), NSForegroundColorAttributeName: [UIColor brightColorForNumber:@([user.userId integerValue])]}];
                    [allLikes appendAttributedString:nameString];
                    if (![[likes lastObject] isEqual:user]) {
                        NSAttributedString *commaString = [[NSAttributedString alloc] initWithString:@", " attributes:@{NSFontAttributeName: FONT_REGULAR(10), NSForegroundColorAttributeName: GRAY_DARK}];
                        [allLikes appendAttributedString:commaString];
                    }
                }
                return [allLikes copy];
            }];

        RAC(self, commentsSummary) =
            [[RACObserve(self, post.comments) ignore:nil] map:^id(NSArray *comments) {
                UIFont *font = FONT_REGULAR(10);
                UIFont *boldFont = FONT_DEMIBOLD(10);
                NSMutableAttributedString *allComments = [[NSMutableAttributedString alloc] init];
                NSAttributedString *spaceString = [[NSAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName: font}];
                NSAttributedString *newLineString = [[NSAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName: font}];
                for (TCSCommentObject *comment in comments) {
                    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:comment.user.userName attributes:@{NSFontAttributeName: boldFont, NSForegroundColorAttributeName: [UIColor brightColorForNumber:@([comment.user.userId integerValue])]}];
                    NSAttributedString *commentString = [[NSAttributedString alloc] initWithString:comment.message attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: GRAY_DARK}];
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
