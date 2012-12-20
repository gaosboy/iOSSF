//
//  KObject.h
//  KacheDemo
//
//  Created by jiajun on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KObject : NSObject

@property (strong, nonatomic) NSMutableDictionary       *object;

- (KObject *)initWithData:(id)data andLifeDuration:(NSInteger)duration;
- (KObject *)initWithDictionary:(NSMutableDictionary *)dict;

- (id)value;
- (NSInteger)expiredTimestamp;
- (void)updateLifeDuration:(NSInteger)duration;
- (BOOL)expired;

@end
