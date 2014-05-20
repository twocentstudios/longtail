//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSPostController.h"

#import "TCSPostObject.h"
#import "TCSGroupObject.h"

#import <FacebookSDK/Facebook.h>
#import <YapDatabase/YapDatabase.h>

#pragma mark -

NSString * const kDatabaseFilename = @"league_hop.sqlite";

NSString * const kDatabaseCollectionPosts = @"posts";
NSString * const kDatabaseCollectionPreferences = @"preferences";

NSString * const kDatabaseKeyLastPostImportDate = @"lastPostImportDate";

NSString * const kDatabaseKeySeparator = @":";

// Example post key -> 0411:20120411:8903248923234890_828902348080
NSUInteger const kDatabasePostKeyMonthDayIndex = 0;
NSUInteger const kDatabasePostKeyYearMonthDayIndex = 1;
NSUInteger const kDatabasePostKeyPostIdIndex = 2;

@implementation TCSPostController

- (RACSignal *)queryPostsForMonthDayKey:(NSString *)monthDayKey {
    return [[[RACSignal return:[[[self class] database] newConnection]]
                subscribeOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault]]
                map:^id(YapDatabaseConnection *connection) {
                    NSLog(@"Starting read posts from database for %@...", monthDayKey);
                    NSMutableArray *array = [NSMutableArray array];
                    [connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
                        [transaction enumerateKeysAndObjectsInCollection:kDatabaseCollectionPosts usingBlock:^(NSString *key, id object, BOOL *stop) {
                            [array addObject:object];
                        } withFilter:^BOOL(NSString *key) {
                            NSString *proposedMonthDayKey = [key componentsSeparatedByString:kDatabaseKeySeparator][kDatabasePostKeyMonthDayIndex];
                            return [proposedMonthDayKey isEqualToString:monthDayKey];
                        }];
                    }];
                    NSLog(@"Read %li posts from database", [array count]);
                    return [array copy];
                }];
}

- (RACSignal *)isImportNeeded {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        YapDatabaseConnection *connection = [[[self class] database] newConnection];
        NSLog(@"Starting last import check...");
        __block NSDate *lastPostImportDate;
        [connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
            lastPostImportDate = [transaction objectForKey:kDatabaseKeyLastPostImportDate inCollection:kDatabaseCollectionPreferences];
        }];
        if (!lastPostImportDate || [lastPostImportDate compare:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*365]] == NSOrderedAscending) {
            NSLog(@"Import will commence");
            [subscriber sendNext:@YES];
        }
        NSLog(@"Import not required at this time");
        [subscriber sendNext:@NO];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)markImportedDate:(NSDate *)importedDate {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        YapDatabaseConnection *connection = [[[self class] database] newConnection];
        [connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
            [transaction setObject:importedDate forKey:kDatabaseKeyLastPostImportDate inCollection:kDatabaseCollectionPreferences];
        }];
        NSLog(@"Last import date set to %@", importedDate);
        [subscriber sendNext:importedDate];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)importPostsForGroups:(NSArray *)groups {
    RACSignal *signal =
        [[[[groups.rac_sequence
            // This sequence must be signalified on the main thread or the FBRequestConnections
            // will never return.
            signalWithScheduler:[RACScheduler mainThreadScheduler]]
            map:^RACSignal *(TCSGroupObject *group) {
                return [self importPostsForSourceID:group.groupId];
            }]
            flatten:1]
            concat:[self markImportedDate:[NSDate date]]];

    return signal;
}

// Sends an array of TCSGroupObjects up to one page.
- (RACSignal *)getGroups {
    NSString *graphPath = [NSString stringWithFormat:@"/me"];
    NSDictionary *parameters = @{ @"fields": @"groups",
                                  @"limit": @"5000" };

    RACSignal *signal = [self requestGraphPath:graphPath parameters:parameters HTTPMethod:nil];

    RACSignal *groupsSignal =
        [[signal
            tryMap:^id(NSDictionary *dictionary, NSError *__autoreleasing *errorPtr) {
                return dictionary[@"groups"][@"data"];
            }]
            tryMap:^id(NSArray *array, NSError *__autoreleasing *errorPtr) {
                return [[[array.rac_sequence.signal tryMap:^id(NSDictionary *postDictionary, NSError *__autoreleasing *errorPtr) {
                            TCSGroupObject *group = [MTLJSONAdapter modelOfClass:[TCSGroupObject class] fromJSONDictionary:postDictionary error:errorPtr];
                                return group;
                        }]
                        filter:^BOOL(TCSGroupObject *group) {  // TEST: remove janelle's list manually
                            return ![group.groupId isEqualToString:@"58936949405"];
                        }]
                        toArray];
            }];

    return groupsSignal;
}

- (RACSignal *)removeAllObjects {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        YapDatabaseConnection *connection = [[[self class] database] newConnection];
        [connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
            [transaction removeAllObjectsInAllCollections];
        }];
        NSLog(@"All objects removed");
        [subscriber sendCompleted];
        return nil;
    }];
}

# pragma mark Private

// Fetches all the posts for the given sourceID then writes them to the database.
// Sends an NSNumber of the number of posts fetched and written.
- (RACSignal *)importPostsForSourceID:(NSString *)sourceID {
    return [[[[RACSignal return:[[[self class] database] newConnection]]
                subscribeOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault]]
                combineLatestWith:[self getPostsForSourceID:sourceID]]
                map:^id(RACTuple *t) {
                    RACTupleUnpack(YapDatabaseConnection *connection, NSArray *posts) = t;
                    NSLog(@"Writing %li posts to database...", [posts count]);
                    [connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
                        for(TCSPostObject *post in posts) {
                            NSString *formattedKey = [@[post.monthDayKey, post.yearMonthDayKey, post.postId] componentsJoinedByString:kDatabaseKeySeparator];
                            [transaction setObject:post forKey:formattedKey inCollection:kDatabaseCollectionPosts];
                        }
                    }];
                    NSLog(@"Writing posts to database complete");
                    return @([posts count]);
                }];
}

// Sends an array of all posts objects from all pages.
- (RACSignal *)getPostsForSourceID:(NSString *)sourceID {
    NSString *graphPath = [NSString stringWithFormat:@"/%@/feed", sourceID];

    RACSignal *signal = [self recursivelyGetDataForGraphPath:graphPath parameters:@{@"limit": @"5000"} startArray:@[]];

    RACSignal *postsSignal =
        [signal tryMap:^id(NSArray *array, NSError *__autoreleasing *errorPtr) {
            return [[array.rac_sequence.signal tryMap:^id(NSDictionary *postDictionary, NSError *__autoreleasing *errorPtr) {
                TCSPostObject *post = [MTLJSONAdapter modelOfClass:[TCSPostObject class] fromJSONDictionary:postDictionary error:errorPtr];
                return post;
            }]
            toArray];
        }];

    return postsSignal;
}

// Recursively pages the graphPath for objects.
// graphPath should be a Facebook graphPath (e.g. /23423423/feed) when called outside this method.
// parameters should not include the authToken when called outside this method.
// startArray should be an empty array when called from outside this method.
// Sends an array of all objects from all pages in raw dictionary form.
- (RACSignal *)recursivelyGetDataForGraphPath:(NSString *)graphPath parameters:(NSDictionary *)parameters startArray:(NSArray *)startArray {
    NSParameterAssert(startArray);

    if (!graphPath) {
        return [RACSignal return:startArray];
    }

    RACSignal *requestSignal;
    if ([graphPath hasPrefix:@"http"]) {
        requestSignal = [self requestURLString:graphPath HTTPMethod:nil];
    } else {
        requestSignal = [self requestGraphPath:graphPath parameters:parameters HTTPMethod:nil];
    }

    @weakify(self);
    return [[requestSignal
                map:^id(NSDictionary *dictionary) {
                    NSArray *array = dictionary[@"data"];
                    NSArray *combinedArray = [startArray arrayByAddingObjectsFromArray:array];
                    NSString *nextURLString = dictionary[@"paging"][@"next"];
                    if (!array || [array count] == 0) {
                        nextURLString = nil; // break recursion if array is empty
                    }
                    return RACTuplePack(combinedArray, nextURLString);
                }]
                flattenMap:^RACStream *(RACTuple *t) {
                    @strongify(self);
                    RACTupleUnpack(NSArray *array, NSString *nextURLString) = t;
                    return [self recursivelyGetDataForGraphPath:nextURLString parameters:nil startArray:array];
                }];
}

// graphPath should be the path component not including host or parameters. Parameters should not include authToken.
- (RACSignal *)requestGraphPath:(NSString *)graphPath parameters:(NSDictionary *)parameters HTTPMethod:(NSString *)HTTPMethod {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        FBRequestConnection *requestConnection =
            [FBRequestConnection
                 startWithGraphPath:graphPath
                 parameters:parameters
                 HTTPMethod:HTTPMethod
                 completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                     if (!error) {
                         [subscriber sendNext:result];
                         [subscriber sendCompleted];
                     } else {
                         [subscriber sendError:error];
                     }
             }];
        return [RACDisposable disposableWithBlock:^{
            [requestConnection cancel];
        }];
    }];
}

// URLString should be a fully formed Facebook URL including host, path, and parameters, including auth token and paging tokens.
// This method is a hack for requesting data using Facebook supplied paging URLs.
- (RACSignal *)requestURLString:(NSString *)URLString HTTPMethod:(NSString *)HTTPMethod {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        FBRequest *request = [[FBRequest alloc] initWithSession:FBSession.activeSession
                                                      graphPath:nil
                                                     parameters:nil
                                                     HTTPMethod:HTTPMethod];
        FBRequestConnection *requestConnection = [[FBRequestConnection alloc] init];
        [requestConnection addRequest:request
             completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     [subscriber sendNext:result];
                     [subscriber sendCompleted];
                 } else {
                     [subscriber sendError:error];
                 }
             }];

        NSURL *URL = [NSURL URLWithString:URLString];
        NSMutableURLRequest* URLRequest = [NSMutableURLRequest requestWithURL:URL];
        URLRequest.HTTPMethod = HTTPMethod ?: @"GET";
        requestConnection.urlRequest = URLRequest;

        [requestConnection start];

        return [RACDisposable disposableWithBlock:^{
            [requestConnection cancel];
        }];
    }];
}

# pragma mark Database Client

+ (YapDatabase *)database {
    static YapDatabase *database;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
        NSString *databasePath = [baseDir stringByAppendingPathComponent:kDatabaseFilename];
        database = [[YapDatabase alloc] initWithPath:databasePath];
        NSAssert(database != nil, @"Database was not created at path %@", databasePath);
    });
    return database;
}

@end
