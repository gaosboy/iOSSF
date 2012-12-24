//
//  SFLoginService.h
//  SegmentFault
//
//  Created by jiajun on 12/23/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

@interface SFLoginService : NSObject

+ (BOOL)isLogin;
+ (BOOL)loginWithInfo:(NSDictionary *)info;
+ (void)logout;

@end
