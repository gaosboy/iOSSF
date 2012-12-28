//
//  SFLoginViewController.m
//  SegmentFault
//
//  Created by jiajun on 12/13/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFLoginViewController.h"
#import "SFLoginService.h"

@interface SFLoginViewController ()

@end

@implementation SFLoginViewController


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self reloadToolBar];
    self.webView.alpha = 0.0f;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *pageSource = [webView stringByEvaluatingJavaScriptFromString: @"document.body.getElementsByTagName('pre').item(0).innerHTML"];
    NSDictionary *loginInfo = (NSDictionary *)[pageSource objectFromJSONString];
    if (loginInfo && 0 == [[loginInfo objectForKey:@"status"] intValue]) {
        if ([SFLoginService loginWithInfo:[loginInfo objectForKey:@"data"]]) {
            if (nil != [self.params objectForKey:@"callback"]) {
                __weak UMViewController *lastViewController = [self.navigator.viewControllers objectAtIndex:(self.navigator.viewControllers.count - 2)];
                SEL callback = NSSelectorFromString([self.params objectForKey:@"callback"]);
                if (lastViewController && callback && [lastViewController respondsToSelector:callback]) {
                    [lastViewController performSelector:callback withObject:nil afterDelay:0.5f];
                }
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

- (void)viewDidLoad
{
    self.url = [NSURL URLWithString:@"http://segmentfault.com/api/user?do=login"];
    [super viewDidLoad];
    
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    self.webView.multipleTouchEnabled = NO;
    self.webView.scalesPageToFit = NO;
    self.webView.delegate = self;
    self.webView.autoresizesSubviews = YES;
}

@end
