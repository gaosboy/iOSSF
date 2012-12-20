//
//  KUtil.m
//  KacheDemo
//
//  Created by jiajun on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KUtil.h"

@implementation KUtil

+ (NSInteger)nowTimestamp {
    return (NSInteger)ceil([[NSDate date] timeIntervalSince1970]); // Use Int For Computing.
}

+ (NSInteger)expiredTimestampForLife:(NSInteger)duration {
    return [KUtil nowTimestamp] + duration;
}

@end
