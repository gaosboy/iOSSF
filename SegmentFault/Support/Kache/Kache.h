//
//  Kache.h
//  KacheDemo
//
//  Created by jiajun on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KQueue;
@class KPool;
@class KHolder;

@interface Kache : NSObject
{
    NSMutableDictionary         *queues;
    NSMutableDictionary         *pools;
    
    KHolder                     *holder;
}

@property (strong, nonatomic)               NSString *filetoken;

- (id)initWithFiletoken:(NSString *)filetoken;

- (void)newQueueWithName:(NSString *)name size:(NSInteger)size;
- (void)newPoolWithName:(NSString *)name size:(NSInteger)size;

- (void)setValue:(id)value forKey:(NSString *)key expiredAfter:(NSInteger)duration;
- (void)setValue:(id)value inPool:(NSString *)name forKey:(NSString *)key expiredAfter:(NSInteger)duration;
- (void)pushValue:(id)value toQueue:(NSString *)name;
- (id)popFromQueue:(NSString *)name;
- (id)valueForKey:(NSString *)key;

- (void)save;
- (void)load;

+ (Kache *)instance;
+ (void)setValue:(id)value forKey:(NSString *)key expiredAfter:(NSInteger)duration;
+ (void)setValue:(id)value inDefaultPoolForKey:(NSString *)key expiredAfter:(NSInteger)duration;
+ (void)pushValue:(id)value;
+ (id)popValue;
+ (id)valueForKey:(NSString *)key;

+ (void)setValue:(id)value inPool:(NSString *)name forKey:(NSString *)key expiredAfter:(NSInteger)duration;
+ (void)pushValue:(id)value toQueue:(NSString *)name;
+ (id)popFromQueue:(NSString *)name;

+ (void)newQueueWithName:(NSString *)name size:(NSInteger)size;
+ (void)newPoolWithName:(NSString *)name size:(NSInteger)size;

+ (void)saveToStorage;
+ (void)loadFromStorage;

@end
