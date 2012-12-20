//
//  KPool.h
//  KacheDemo
//
//  Created by jiajun on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KHolder;

@interface KPool : NSObject
{
    KHolder         *holder;
    NSMutableArray  *pool;
}

@property (assign, nonatomic) NSInteger         size;
@property (assign, nonatomic) NSString          *name;

- (KPool *)initWithHolder:(KHolder *)holder;
- (void)setValue:(id)value forKey:(NSString *)key expiredAfter:(NSInteger)duration;

- (NSDictionary *)serialize;
- (void)unserializeFrom:(NSDictionary *)dict;

@end
