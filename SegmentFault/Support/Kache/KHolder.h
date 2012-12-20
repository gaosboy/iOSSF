//
//  KHolder.h
//  KacheDemo
//
//  Created by jiajun on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KQueue;
@class KPool;
@class KObject;

@interface KHolder : NSObject
{
    NSMutableDictionary         *objects;
    NSMutableArray              *keys;
}

- (void)setValue:(id)value forKey:(NSString *)key expiredAfter:(NSInteger)duration;
- (id)valueForKey:(NSString *)key;
- (KObject *)objectForKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;

- (NSDictionary *)serialize;
- (void)unserializeFrom:(NSDictionary *)dict;

@end
