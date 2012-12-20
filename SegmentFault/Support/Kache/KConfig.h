//
//  KConfig.h
//  KacheDemo
//
//  Created by jiajun on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// If it is set as 1 it use two level storage. Once more than
// 100 objects stored in memory, the earliest objects will be
// archived to disk storaged.
#define     KACHE_AUTO_ARCH             0
#define     KACHE_ARCH_THREHOLD_VALUE   500

#define     KACHE_DEFAULT_POOL_SIZE     20
#define     KACHE_DEFAULT_QUEUE_SIZE    10

// Default expired time, 10 Days.
#define     KACHE_DEFAULT_LIFE_DURATION 864000