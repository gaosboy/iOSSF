//
//  SFQuestion.m
//  SegmentFault
//
//  Created by jiajun on 12/14/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFQuestion.h"
#import "AFJSONRequestOperation.h"

@interface SFQuestionHttpClient ()

@end

@implementation SFQuestionHttpClient

+ (SFQuestionHttpClient *)sharedClient
{
    static SFQuestionHttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[SFQuestionHttpClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://segmentfault.com/"]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

@end

@implementation SFQuestion

+ (void)questionListByPath:(NSString *)path
                         onPage:(NSInteger)page size:(NSInteger)size
                      withBlock:(void (^)(NSArray *questions, NSError *error))block
{
    // From Internet
    [[SFQuestionHttpClient sharedClient] getPath:path parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                             [NSString stringWithFormat:@"%d", page], @"page",
                                                                             [NSString stringWithFormat:@"%d", size], @"size",
                                                                             nil]
                                         success:^(AFHTTPRequestOperation *operation, id JSON) {
                                             NSDictionary *data = [JSON valueForKeyPath:@"data"];
                                             if (block) {
                                                 block([data objectForKey:@"items"], nil);
                                             }
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             if (block) {
                                                 block([NSArray array], error);
                                             }
                                         }];
}

@end
