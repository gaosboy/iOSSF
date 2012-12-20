//
//  SFQuestion.m
//  SegmentFault
//
//  Created by jiajun on 12/14/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFQuestion.h"
#import "CNHttpReqeust.h"

@implementation SFQuestion

+ (void)listQuestionByCondition:(NSString *)condition onPage:(NSInteger)page size:(NSInteger)size delegate:(id)aDelegate
{
    [CNHttpReqeust invoke:@"http://segmentfault.com/api/question"
                   params:[NSDictionary dictionaryWithObjectsAndKeys:
                           [NSString stringWithFormat:@"list%@", condition], @"do",
                           [NSString stringWithFormat:@"%d", page], @"page",
                           [NSString stringWithFormat:@"%d", size], @"size",
                           nil]
                 userInfo:nil
                 delegate:aDelegate
                onSuccess:@selector(requestFinished:)
                onFailure:nil
               onComplete:@selector(requestCompleted)];
}

+ (NSArray *)getListFromResponse:(NSString *)responseString
{
    NSDictionary *dict = [responseString JSONValue];
    if (0 == [[dict objectForKey:@"status"] intValue]) {
        return [[[responseString JSONValue] objectForKey:@"data"] objectForKey:@"items"];
    }
    else {
        return nil;
    }
}

@end
