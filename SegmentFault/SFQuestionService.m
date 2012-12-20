//
//  SFQuestionService.m
//  SegmentFault
//
//  Created by jiajun on 12/14/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFQuestionService.h"
#import "SFQuestion.h"

@implementation SFQuestionService

+ (void)getNewestQuestionListPage:(NSInteger)page delegate:(id)aDelegate
{
    [SFQuestion listQuestionByCondition:@"newest" onPage:page size:30 delegate:aDelegate];
}

+ (NSArray *)getQuestionList:(NSString *)string
{
    return [SFQuestion getListFromResponse:string];
}

@end
