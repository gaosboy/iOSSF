//
//  KHolder.m
//  KacheDemo
//
//  Created by jiajun on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KHolder.h"

#import "KQueue.h"
#import "KPool.h"
#import "KUtil.h"
#import "KObject.h"
#import "KConfig.h"

@interface KHolder ()

@property (strong, nonatomic)   NSMutableDictionary         *objects;
@property (strong, atomic)      NSMutableArray              *keys;

- (void)cleanExpiredObjects;

@end

@implementation KHolder

@synthesize objects     = _objects;
@synthesize keys        = _keys;

#pragma mark - init

- (id)init
{
    self = [super init];
    if (self) {
        self.objects = [[NSMutableDictionary alloc] init];
        self.keys = [[NSMutableArray alloc] init];
        
        return self;
    }

    return nil;
}

#pragma mark - private

- (void)cleanExpiredObjects
{
    if (self.keys && 0 < [self.keys count]) {
        for (int i = 0; i < [self.keys count] - 1; i ++) {
            NSString *tmpKey = [self.keys objectAtIndex:i];
            KObject *leftObject = [self objectForKey:tmpKey];
            if ([leftObject expiredTimestamp] < [KUtil nowTimestamp]) {
                [self.keys removeObject:tmpKey];
                [self.objects removeObjectForKey:tmpKey];
            }
            else {
                break;
            }
        }
    }
}

#pragma mark - public

- (void)removeObjectForKey:(NSString *)key {
    [self.keys removeObject:key];
    [self.objects removeObjectForKey:key];
}

- (void)setValue:(id)value forKey:(NSString *)key expiredAfter:(NSInteger)duration
{
    KObject *object = [[KObject alloc] initWithData:value andLifeDuration:duration];

    [self.objects setValue:object.object forKey:key];
    KObject *suchObject = [self objectForKey:key];

    // TODO sort the key by expired time.
    [self.keys removeObject:key];
    
    if (0 < [self.keys count]) {
        [self cleanExpiredObjects];

        for (int i = [self.keys count] - 1; i >= 0; i --) {
            NSString *tmpKey = [self.keys objectAtIndex:i];
            KObject *leftObject = [self objectForKey:tmpKey];
            if ([leftObject expiredTimestamp] <= [suchObject expiredTimestamp]) {
                if (([self.keys count] - 1) == i) {
                    [self.keys addObject:key];
                }
                else {
                    [self.keys insertObject:key atIndex:i + 1];
                }
                break;
            }
        }
    }
    if (! [self.keys containsObject:key]) {
        [self.keys insertObject:key atIndex:0];
    }
}

- (id)valueForKey:(NSString *)key
{
    KObject *object = [self objectForKey:key];
    if (object && ! [object expired]) {
        return [object value];
    }
    // No such object.
    return nil;
}

- (KObject *)objectForKey:(NSString *)key
{
    if ([[self.objects allKeys] containsObject:key]) {
        return [[KObject alloc] initWithDictionary:[self.objects objectForKey:key]];
    }
    
    return nil;
}

// Convert object to NSDictionary.
- (NSDictionary *)serialize
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.objects, @"objects",
            self.keys, @"keys",
            nil];
}

// Convert NSDictionary to object.
- (void)unserializeFrom:(NSDictionary *)dict
{
    if ([[dict allKeys] containsObject:@"objects"]
        && [[dict allKeys] containsObject:@"keys"]) {
        self.objects = [dict objectForKey:@"objects"];
        self.keys = [dict objectForKey:@"keys"];
    }
}

@end
