//
//  KPool.m
//  KacheDemo
//
//  Created by jiajun on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KPool.h"

#import "KHolder.h"
#import "KObject.h"

#import "KUtil.h"
#import "KConfig.h"

@interface KPool ()

@property (strong, nonatomic)   KHolder               *holder;
@property (strong, atomic)      NSMutableArray        *pool;

- (void)cleanExpiredObjects;

@end

@implementation KPool

@synthesize size                = _size;
@synthesize name                = _name;
@synthesize holder              = _holder;
@synthesize pool                = _pool;

#pragma mark - init

- (KPool *)initWithHolder:(KHolder *)aHolder
{
    self = [super init];
    
    if (self) {
        self.holder = aHolder;
        self.pool = [[NSMutableArray alloc] init];
        self.size   = KACHE_DEFAULT_POOL_SIZE;
        
        return self;
    }
    
    return nil;
}

#pragma mark - private

- (void)cleanExpiredObjects
{
    if (self.pool && 0 < [self.pool count]) {
        for (int i = 0; i < [self.pool count] - 1; i ++) {
            NSString *tmpKey = [self.pool objectAtIndex:i];
            KObject *leftObject = [self.holder objectForKey:tmpKey];
            if ([leftObject expiredTimestamp] < [KUtil nowTimestamp]) {
                [self.pool removeObject:tmpKey];
            }
            else {
                break;
            }
        }
    }
}

#pragma mark - public

- (void)setValue:(id)value forKey:(NSString *)key expiredAfter:(NSInteger)duration
{
    [self.holder setValue:value forKey:key expiredAfter:duration];
    KObject *suchObject = [self.holder objectForKey:key];
    [self.pool removeObject:key];

    if (0 < [self.pool count]) {
        [self cleanExpiredObjects];
        
        if (self.size <= [self.pool count]) {
            [self.holder removeObjectForKey:[self.pool objectAtIndex:0]];
            [self.pool removeObjectAtIndex:0];
        }
        
        for (int i = [self.pool count] - 1; i >= 0; i --) {
            NSString *tmpKey = [self.pool objectAtIndex:i];
            KObject *leftObject = [self.holder objectForKey:tmpKey];
            if ([leftObject expiredTimestamp] <= [suchObject expiredTimestamp]) {
                if (([self.pool count] - 1) == i) {
                    [self.pool addObject:key];
                }
                else {
                    [self.pool insertObject:key atIndex:i + 1];
                }
                break;
            }
        }
    }
    if (! [self.pool containsObject:key]) {
        [self.pool insertObject:key atIndex:0];
    }
}

- (NSDictionary *)serialize
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.pool,                                      @"pool",
            [NSString stringWithFormat:@"%d", self.size],   @"size",
            self.name,                                      @"name",
            nil];
}

- (void)unserializeFrom:(NSDictionary *)dict
{
    if ([[dict allKeys] containsObject:@"size"]
        && [[dict allKeys] containsObject:@"name"]
        &&[[dict allKeys] containsObject:@"pool"]) {
        self.size   = [[dict objectForKey:@"size"] intValue];
        self.name   = [NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]];
        self.pool   = [[dict objectForKey:@"pool"] mutableCopy];
    }
}

@end
