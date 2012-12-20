//
//  SFQuestionService.h
//  SegmentFault
//
//  Created by jiajun on 12/14/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

@interface SFQuestionService : NSObject

+ (void)getNewestQuestionListPage:(NSInteger)page withBlock:(void (^)(NSArray *questions, NSError *error))block;

@end
