//
//  SFQuestionDetailViewController.m
//  SegmentFault
//
//  Created by jiajun on 12/12/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFQuestionDetailViewController.h"

@interface SFQuestionDetailViewController ()

@end

@implementation SFQuestionDetailViewController

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self reloadToolBar];
    self.webView.alpha = 0.0f;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self reloadToolBar];
    [webView stringByEvaluatingJavaScriptFromString:
     @"document.body.removeChild(document.getElementById('header'));document.body.removeChild(document.getElementById('footer'));"];
    self.webView.alpha = 1.0f;

    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {
        if ([@".segmentfault.com" isEqualToString:[cookie domain]]
            && [@"sfsess" isEqualToString:[cookie name]]) {
            [[NSUserDefaults standardUserDefaults] setValue:[cookie value] forKey:@"sfsess"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)loadRequest {
    if (! [@"http" isEqualToString:[self.url protocol]]) {
        self.url = [NSURL URLWithString:[self.params objectForKey:@"url"]];
    }
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:self.url];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"sfsess", NSHTTPCookieName,
                             [[NSUserDefaults standardUserDefaults] valueForKey:@"sfsess"], NSHTTPCookieValue,
                             @".segmentfault.com", NSHTTPCookieDomain,
                             @"segmentfault.com", NSHTTPCookieOriginURL,
                             @"/", NSHTTPCookiePath,
                             @"0", NSHTTPCookieVersion,
                             nil]];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];

    [self.webView loadRequest:requestObj];
}

- (id)initWithURL:(NSURL *)aUrl
{
    self = [super initWithURL:aUrl];
    if (self) {
        self.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://segmentfault.com/q/%@", [[aUrl params] objectForKey:@"qid"]]];
        return self;
    }
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    self.webView.multipleTouchEnabled = NO;
    self.webView.scalesPageToFit = NO;
    self.webView.delegate = self;
    self.webView.autoresizesSubviews = YES;

	// Do any additional setup after loading the view.
}

@end
