//
//  SFLoginViewController.m
//  SegmentFault
//
//  Created by jiajun on 12/13/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFLoginService.h"
#import "SFLoginViewController.h"
#import "SFAppDelegate.h"
#import "SFSlideNavViewController.h"

@interface SFLoginViewController ()

- (void)login;

@end

@implementation SFLoginViewController

#pragma mark - private

- (void)login
{
    // 调用SlideNavigator，刷新导航栏目
    [[SFTools applicationDelegate].navigator performSelector:@selector(login)];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self reloadToolBar];
    self.webView.alpha = 0.0f;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{    
    NSMutableDictionary *loginInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"400", @"status", nil];
    NSHTTPCookie *cookie;
    for (cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if ([@"sfuid" isEqualToString:cookie.name] && 0 < cookie.value.length) {
            [loginInfo setValue:cookie.value forKey:@"sfuid"];
            [loginInfo setValue:@"0" forKey:@"status"];
        }
        else if ([@"sfsess" isEqualToString:cookie.name]) {
            [loginInfo setValue:cookie.value forKey:@"sfsess"];
        }
    }
    
    if (loginInfo && 0 == [loginInfo[@"status"] intValue]) {
        if ([SFLoginService loginWithInfo:loginInfo]) {
            if (nil != self.params[@"callback"]) {
                __weak UMViewController *lastViewController = self.navigator.viewControllers [(self.navigator.viewControllers.count > 1)
                                                                                              ? (self.navigator.viewControllers.count - 2) : 0];
                SEL callback = NSSelectorFromString(self.params[@"callback"]);
                if (lastViewController && callback && [lastViewController respondsToSelector:callback]) {
                    [lastViewController performSelector:callback withObject:nil afterDelay:0.5f];
                }
            }
            else {
                [self login];
            }
            [self.navigator popViewControllerAnimated:YES];
        }
        else {
            [SFLoginService logout];
            [self loadRequest];
            self.webView.alpha = 1.0f;
        }
    }
    else {
        self.webView.alpha = 1.0f;
    }
    [super webViewDidFinishLoad:webView];
}

#pragma mark

- (void)viewDidLoad
{
    self.url = [NSURL URLWithString:@"http://segmentfault.com/user/login"];
    [super viewDidLoad];
    
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    self.webView.multipleTouchEnabled = NO;
    self.webView.scalesPageToFit = NO;
    self.webView.delegate = self;
    self.webView.autoresizesSubviews = YES;
}

@end
