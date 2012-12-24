//
//  SFLoginService.m
//  SegmentFault
//
//  Created by jiajun on 12/23/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFLoginService.h"

@implementation SFLoginService

+ (BOOL)isLogin
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"sfsess"]
        && [[NSUserDefaults standardUserDefaults] valueForKey:@"sfuid"]) {
        return YES;
    } else {
        [SFLoginService logout];
        return NO;
    }
}

+ (BOOL)loginWithInfo:(NSDictionary *)info
{
    BOOL statusCookie = NO;
    BOOL statusUID = NO;
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {
        if ([@".segmentfault.com" isEqualToString:[cookie domain]]
            && [@"sfsess" isEqualToString:[cookie name]]) {
            [[NSUserDefaults standardUserDefaults] setValue:[cookie value] forKey:@"sfsess"];
            statusCookie = YES;
        }
    }
    if (info && 0 < [[info objectForKey:@"id"] length]) {
        [[NSUserDefaults standardUserDefaults] setValue:[info objectForKey:@"id"] forKey:@"sfuid"];
        statusUID = YES;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];

    return statusCookie && statusUID;
}

+ (void)logout
{
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"sfsess"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"sfuid"];
}

@end
