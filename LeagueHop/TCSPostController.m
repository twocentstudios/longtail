//
//  LeagueHop
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSPostController.h"

#import "TCSPostObject.h"

#import <FacebookSDK/Facebook.h>

#pragma mark -

@implementation TCSPostController

- (RACSignal *)importPostsForSourceID:(NSNumber *)sourceID {
    return nil;
}

+ (RACSignal *)getPostsForSourceID:(NSNumber *)sourceID {
    NSString *graphPath = [NSString stringWithFormat:@"/%@/feed", sourceID];
    RACSignal *signal = [[self class] requestGraphPath:graphPath parameters:nil HTTPMethod:nil];
    signal =
        [[signal tryMap:^id(NSDictionary *dictionary, NSError *__autoreleasing *errorPtr) {
            NSArray *array = dictionary[@"data"];
            return array;
        }] tryMap:^id(NSArray *array, NSError *__autoreleasing *errorPtr) {
            return [[array.rac_sequence.signal tryMap:^id(NSDictionary *dictionary, NSError *__autoreleasing *errorPtr) {
                TCSPostObject *post = [MTLJSONAdapter modelOfClass:[TCSPostObject class] fromJSONDictionary:dictionary error:errorPtr];
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

@end
