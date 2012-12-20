//
//  SFQuestionService.h
//  SegmentFault
//
//  Created by jiajun on 12/14/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

@interface SFQuestionService : NSObject

+ (void)getNewestQuestionListPage:(NSInteger)page delegate:(id)aDelegate;
+ (NSArray *)getQuestionList:(NSString *)string;

@end
