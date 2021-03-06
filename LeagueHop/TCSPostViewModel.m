//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSPostViewModel.h"

#import "TCSWebViewModel.h"

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
@property (nonatomic) NSAttributedString *likesSummary;
@property (nonatomic) NSAttributedString *commentsSummary;

@property (nonatomic) RACCommand *openLinkCommand;

@end

#pragma mark -

@implementation TCSPostViewModel

- (instancetype)initWithPost:(TCSPostObject *)post openURLCommand:(RACCommand *)openURLCommand {
    self = [super init];
    if (self != nil) {
        _post = post;
        _openURLCommand = openURLCommand;

        RAC(self, userName) =
            [[RACObserve(self, post.user) ignore:nil] map:^NSAttributedString *(TCSUserObject *user) {
                return [[NSAttributedString alloc] initWithString:user.userName attributes:@{NSFontAttributeName: FONT_DEMIBOLD(18), NSForegroundColorAttributeName: [UIColor brightColorForFacebookUserId:user.userId]}];
            }];

        RAC(self, postSummary) =
            [[RACObserve(self, post) ignore:nil] map:^NSAttributedString *(TCSPostObject *post) {
                NSMutableAttributedString *summary = [[NSMutableAttributedString alloc] init];
                NSDictionary *lightAttributes = @{NSFontAttributeName: FONT_LIGHT(13), NSForegroundColorAttributeName: GRAY_DARK};
                NSDictionary *boldAttributes = @{NSFontAttributeName: FONT_MEDIUM(13), NSForegroundColorAttributeName: GRAY_MEDIUM};
                [summary appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"posted a ", nil) attributes:lightAttributes]];
                [summary appendAttributedString:[[NSAttributedString alloc] initWithString:post.type attributes:boldAttributes]];
                [summary appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@" in ", nil) attributes:lightAttributes]];
                [summary appendAttributedString:[[NSAttributedString alloc] initWithString:post.sourceObject.sourceName attributes:boldAttributes]];
                return [summary copy];
            }];

        RAC(self, message) =
            [[RACObserve(self, post) ignore:nil] map:^NSAttributedString *(TCSPostObject *post) {
                NSString *message = post.message;
                NSString *linkURLString = [post.linkURL absoluteString];
                NSString *maybeLinkURLString = (linkURLString && [message rangeOfString:linkURLString].length == 0) ? linkURLString : nil;
                NSMutableAttributedString *fullMessage = [[NSMutableAttributedString alloc] init];
                NSDictionary *messageAttributes = @{NSFontAttributeName: FONT_MEDIUM(22), NSForegroundColorAttributeName: GRAY_BLACK};
                NSDictionary *linkAttributes = @{NSFontAttributeName: FONT_MEDIUM(18), NSForegroundColorAttributeName: GRAY_MEDIUM};
                if (message) {
                    [fullMessage appendAttributedString:[[NSAttributedString alloc] initWithString:message attributes:messageAttributes]];
                }
                if (maybeLinkURLString) {
                    if (message) {
                        [fullMessage appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:messageAttributes]];
                    }
                    [fullMessage appendAttributedString:[[NSAttributedString alloc] initWithString:maybeLinkURLString attributes:linkAttributes]];
                }
                return [fullMessage copy];
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
                return [[NSAttributedString alloc] initWithString:dateString attributes:@{NSFontAttributeName: FONT_MEDIUM(15), NSForegroundColorAttributeName: GRAY_DARK}];
            }];

        RAC(self, likesSummary) =
            [[RACObserve(self, post.likes) ignore:nil] map:^id(NSArray *likes) {
                NSMutableAttributedString *allLikes = [[NSMutableAttributedString alloc] init];
                NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"👍 ", nil) attributes:@{NSFontAttributeName: FONT_DEMIBOLD(12), NSForegroundColorAttributeName: GRAY_MEDIUM}];
                [allLikes appendAttributedString:titleString];
                for (TCSUserObject *user in likes) {
                    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:user.userName attributes:@{NSFontAttributeName: FONT_DEMIBOLD(12), NSForegroundColorAttributeName: [UIColor brightColorForFacebookUserId:user.userId]}];
                    [allLikes appendAttributedString:nameString];
                    if (![[likes lastObject] isEqual:user]) {
                        NSAttributedString *commaString = [[NSAttributedString alloc] initWithString:@", " attributes:@{NSFontAttributeName: FONT_REGULAR(12), NSForegroundColorAttributeName: GRAY_DARK}];
                        [allLikes appendAttributedString:commaString];
                    }
                }
                return [allLikes copy];
            }];

        RAC(self, commentsSummary) =
            [[RACObserve(self, post.comments) ignore:nil] map:^id(NSArray *comments) {
                UIFont *font = FONT_REGULAR(14);
                UIFont *boldFont = FONT_DEMIBOLD(14);
                NSMutableAttributedString *allComments = [[NSMutableAttributedString alloc] init];
                NSAttributedString *spaceString = [[NSAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName: font}];
                NSAttributedString *newLineString = [[NSAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName: font}];
                for (TCSCommentObject *comment in comments) {
                    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:comment.user.userName attributes:@{NSFontAttributeName: boldFont, NSForegroundColorAttributeName: [UIColor brightColorForFacebookUserId:comment.user.userId]}];
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
