//
//  SFQuestionService.h
//  SegmentFault
//
//  Created by jiajun on 12/14/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFQuestion.h"

@interface SFQuestionService : NSObject

+ (void)getQuestionDetailById:(NSString *)qid withBlock:(SFQuestionDetailLoadedBlock)block;
+ (void)getQuestionList:(NSString *)list onPage:(NSInteger)page withBlock:(void (^)(NSArray *questions, NSError *error))block;

@end
