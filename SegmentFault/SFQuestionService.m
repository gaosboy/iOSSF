//
//  SFQuestionService.m
//  SegmentFault
//
//  Created by jiajun on 12/14/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFQuestionService.h"

@implementation SFQuestionService

+ (void)getNewestQuestionListPage:(NSInteger)page
                        withBlock:(void (^)(NSArray *questions, NSError *error))block

{
    [SFQuestion questionListByCondition:@"newest" onPage:page size:30 withBlock:block];
}

@end
ring
{
    return [SFQuestion getListFromResponse:string];
}

@end
