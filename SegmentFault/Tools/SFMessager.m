//
//  SFMessager.m
//  SegmentFault
//
//  Created by jiajun on 1/13/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import "SFMessager.h"

@interface NSObject ()

@property (strong, atomic)  NSMutableDictionary         *messages;

+ (SFMessager *)instance;

@end

@implementation SFMessager

@synthesize messages;

- (id)init
{
    self = [super init];
    if (self) {
        self.messages = [[NSMutableDictionary alloc] init];
        return self;
    }
    return nil;
}

+ (SFMessager *)instance
{
    static SFMessager *obj = nil;
    if (nil == obj) {
        obj = [[SFMessager alloc] init];
    }
    return obj;
}

+ (void)addMessage:(NSString *)message forKey:(NSString *)key
{
    [[SFMessager instance].messages setValue:message forKey:key];
}

+ (NSString *)messageForKey:(NSString *)key
{
    NSString *message = [[SFMessager instance].messages valueForKey:key];
    [[SFMessager instance].messages removeObjectForKey:key];
    return message;
}

@end
