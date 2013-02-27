//
//  SFLoginService.m
//  SegmentFault
//
//  Created by jiajun on 12/23/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFLoginService.h"
#import "UMViewController.h"

@implementation SFLoginService

+ (BOOL)isLogin
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"sfsess"] length]
        && [[[NSUserDefaults standardUserDefaults] valueForKey:@"sfuid"] length]) {
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
    if (info && 0 < [info[@"sfsess"] length]) {
        [[NSUserDefaults standardUserDefaults] setValue:info[@"sfsess"] forKey:@"sfsess"];
        statusCookie = YES;
    }
    if (info && 0 < [info[@"sfuid"] length]) {
        [[NSUserDefaults standardUserDefaults] setValue:info[@"sfuid"] forKey:@"sfuid"];
        statusUID = YES;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];

    return statusCookie && statusUID;
}

+ (void)logout
{
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"sfsess"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"sfuid"];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"sfsess", NSHTTPCookieName,
                             @"", NSHTTPCookieValue,
                             @".segmentfault.com", NSHTTPCookieDomain,
                             @"segmentfault.com", NSHTTPCookieOriginURL,
                             @"/", NSHTTPCookiePath,
                             @"0", NSHTTPCookieVersion,
                             nil]];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    NSHTTPCookie *uidCookie = [NSHTTPCookie cookieWithProperties:
                               [NSDictionary dictionaryWithObjectsAndKeys:
                                @"sfuid", NSHTTPCookieName,
                                @"", NSHTTPCookieValue,
                                @".segmentfault.com", NSHTTPCookieDomain,
                                @"segmentfault.com", NSHTTPCookieOriginURL,
                                @"/", NSHTTPCookiePath,
                                @"0", NSHTTPCookieVersion,
                                nil]];

    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:uidCookie];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SFNotificationLogout object:nil];
}

+ (void)login:(UMViewController *)vc withCallback:(NSString *)callback
{
    [vc.navigator openURL:[[NSURL URLWithString:@"sf://login"] addParams:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                            @"登录", @"title",
                                                                            callback, @"callback",
                                                                            nil]]];
}

@end
