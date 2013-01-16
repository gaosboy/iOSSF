//
//  SFQuestion.h
//  SegmentFault
//
//  Created by jiajun on 12/14/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

typedef void (^SFQuestionDetailLoadedBlock)(NSDictionary *questionInfo, NSInteger answers, NSError *error);
typedef void (^SFQuestionListLoadedBlock)(NSArray *questions, NSError *error);

@interface SFQuestionHttpClient : AFHTTPClient

+ (SFQuestionHttpClient *)sharedClient;

@end

@interface SFQuestion : NSObject

+ (void)questionDetailBy:(NSString *)qid
               withBlock:(SFQuestionDetailLoadedBlock)block;
+ (void)questionListByPath:(NSString *)path
                         onPage:(NSInteger)page size:(NSInteger)size
                      withBlock:(SFQuestionListLoadedBlock)block;

@end
