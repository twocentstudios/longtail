//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSPostController.h"

#import "TCSPostObject.h"

#import <FacebookSDK/Facebook.h>
#import <YapDatabase/YapDatabase.h>

#pragma mark -

NSString * const kDatabaseCollectionPosts = @"posts";
NSString * const kDatabaseCollectionPreferences = @"preferences";

NSString * const kDatabaseKeyLastPostImportDate = @"lastPostImportDate";
NSString * const kDatabaseKeyTotalImportedPosts = @"totalImportedPosts";

NSString * const kDatabaseKeySeparator = @":";

// Example post key -> 0411:20120411:8903248923234890_828902348080
NSUInteger const kDatabasePostKeyMonthDayIndex = 0;
NSUInteger const kDatabasePostKeyYearMonthDayIndex = 1;
NSUInteger const kDatabasePostKeyPostIdIndex = 2;

@implementation TCSPostController

- (RACSignal *)fetchPostsForMonthDayKey:(NSString *)monthDayKey {
    return [[[RACSignal return:[[[self class] database] newConnection]]
                subscribeOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault]]
                map:^id(YapDatabaseConnection *connection) {
                    NSMutableArray *array = [NSMutableArray array];
                    [connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
                        [transaction enumerateKeysAndObjectsInCollection:kDatabaseCollectionPosts usingBlock:^(NSString *key, id object, BOOL *stop) {
                            [array addObject:object];
                        } withFilter:^BOOL(NSString *key) {
                            NSString *proposedMonthDayKey = [key componentsSeparatedByString:kDatabaseKeySeparator][kDatabasePostKeyMonthDayIndex];
                            return [proposedMonthDayKey isEqualToString:monthDayKey];
                        }];
                    }];
                    return [array copy];
                }];
}

- (RACSignal *)importPostsForSourceID:(NSNumber *)sourceID {
    return [[[[[[[RACSignal return:[[[self class] database] newConnection]]
                subscribeOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault]]
                tryMap:^id(YapDatabaseConnection *connection, NSError *__autoreleasing *errorPtr) {
                    __block NSDate *lastPostImportDate;
                    [connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
                        lastPostImportDate = [transaction objectForKey:kDatabaseKeyLastPostImportDate inCollection:kDatabaseCollectionPreferences];
                    }];
                    if (lastPostImportDate && [lastPostImportDate compare:[NSDate dateWithTimeIntervalSinceNow:60*60*24*365]] == NSOrderedDescending) {
                        return nil;
                    }
                    return connection;
                }]
                combineLatestWith:[[self class] getPostsForSourceID:sourceID]]
                map:^id(RACTuple *t) {
                    RACTupleUnpack(YapDatabaseConnection *connection, NSArray *posts) = t;
                    [connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
                        for(TCSPostObject *post in posts) {
                            NSString *formattedKey = [@[post.monthDayKey, post.yearMonthDayKey, post.postId] componentsJoinedByString:kDatabaseKeySeparator];
                            [transaction setObject:post forKey:formattedKey inCollection:kDatabaseCollectionPosts];
                        }
                    }];
                    return RACTuplePack(connection, @([posts count]));
                }]
                map:^id(RACTuple *t) {
                    RACTupleUnpack(YapDatabaseConnection *connection, NSNumber *totalImportedPosts) = t;
                    [connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
                        [transaction setObject:totalImportedPosts forKey:kDatabaseKeyTotalImportedPosts inCollection:kDatabaseCollectionPreferences];
                        [transaction setObject:[NSDate date] forKey:kDatabaseKeyLastPostImportDate inCollection:kDatabaseCollectionPreferences];
                    }];
                    return [RACSignal empty];
                }]
                catchTo:[RACSignal empty]];
}

# pragma mark FBClient

+ (RACSignal *)getPostsForSourceID:(NSNumber *)sourceID {
    NSString *graphPath = [NSString stringWithFormat:@"/%@/feed", sourceID];

    RACSignal *signal =
        [[[[self class] requestGraphPath:graphPath parameters:nil HTTPMethod:nil]
            tryMap:^id(NSDictionary *dictionary, NSError *__autoreleasing *errorPtr) {
                NSArray *array = dictionary[@"data"];
                return array;
            }]
            tryMap:^id(NSArray *array, NSError *__autoreleasing *errorPtr) {
                return [[array.rac_sequence.signal tryMap:^id(NSDictionary *postDictionary, NSError *__autoreleasing *errorPtr) {
                    TCSPostObject *post = [MTLJSONAdapter modelOfClass:[TCSPostObject class] fromJSONDictionary:postDictionary error:errorPtr];
                    return post;
                }] toArray];
            }];

    return signal;
}

+ (RACSignal *)requestGraphPath:(NSString *)graphPath parameters:(NSDictionary *)parameters HTTPMethod:(NSString *)HTTPMethod {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        FBRequestConnection *connection =
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
            [connection cancel];
        }];
    }];
}

# pragma mark Database Client

+ (YapDatabase *)database {
    static YapDatabase *database;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        database = [[YapDatabase alloc] initWithPath:@"leaguehop"];
    });
    return database;
}

@end
