//
//  SFQuestion.h
//  SegmentFault
//
//  Created by jiajun on 12/14/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFQuestion : NSObject

+ (void)listQuestionByCondition:(NSString *)condition onPage:(NSInteger)page size:(NSInteger)size delegate:(id)aDelegate;
+ (NSArray *)getListFromResponse:(NSString *)responseString;

@end
