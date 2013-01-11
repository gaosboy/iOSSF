//
//  SFQuestionService.m
//  SegmentFault
//
//  Created by jiajun on 12/14/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFQuestionService.h"

@implementation SFQuestionService

+ (void)getQuestionList:(NSString *)list onPage:(NSInteger)page
              withBlock:(SFQuestionListLoadedBlock)block
{
    [SFQuestion questionListByPath:[NSString stringWithFormat:@"api/question?do=%@", list]
                            onPage:page
                              size:30
                         withBlock:block];
}

+ (void)getQuestionDetailById:(NSString *)qid
                    withBlock:(SFQuestionDetailLoadedBlock)block
{
    [SFQuestion questionDetailBy:qid withBlock:block];
}

@end
