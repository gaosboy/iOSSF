//
//  KUtil.h
//  KacheDemo
//
//  Created by jiajun on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KUtil : NSObject

+ (NSInteger)expiredTimestampForLife:(NSInteger)duration;
+ (NSInteger)nowTimestamp;

@end
