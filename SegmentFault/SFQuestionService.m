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
              withBlock:(void (^)(NSArray *questions, NSError *error))block
{
    [SFQuestion questionListByPath:[NSString stringWithFormat:@"api/question?do=%@", list]
                            onPage:page
                              size:30
                         withBlock:block];
}

@end
