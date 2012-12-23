//
//  SFQuestion.h
//  SegmentFault
//
//  Created by jiajun on 12/14/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface SFQuestionHttpClient : AFHTTPClient

+ (SFQuestionHttpClient *)sharedClient;

@end

@interface SFQuestion : NSObject

+ (void)questionListByPath:(NSString *)path
                         onPage:(NSInteger)page size:(NSInteger)size
                      withBlock:(void (^)(NSArray *questions, NSError *error))block;

@end
