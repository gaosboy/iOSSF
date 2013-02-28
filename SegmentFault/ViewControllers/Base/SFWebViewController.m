//
//  SFWebViewController.m
//  SegmentFault
//
//  Created by jiajun on 12/12/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFWebViewController.h"
#import "UMSlideNavigationController.h"

@interface SFWebViewController ()

- (void)back;
- (void)dismissKeyboard;

@end

@implementation SFWebViewController

#pragma mark - private

- (void)back
{
    [self.navigator popViewControllerAnimated:YES];
}

- (void)dismissKeyboard
{
    [self.webView endEditing:YES];
}

#pragma mark - parent

- (void)loadRequest {
    if (! [@"http" isEqualToString:[self.url protocol]]) {
        self.url = [NSURL URLWithString:self.params[@"url"]];
    }
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:self.url];
    [self.webView loadRequest:requestObj];
}

- (void)openedFromViewControllerWithURL:(NSURL *)aUrl
{
    UIButton *navBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [navBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navBtn setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [navBtn setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateHighlighted];
    navBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:navBtn];
    self.navigationItem.leftBarButtonItem = btnItem;
}

#pragma mark - WebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
    [webView stringByEvaluatingJavaScriptFromString:
     @"document.body.removeChild(document.getElementById('header'));document.body.removeChild(document.getElementById('footer'));"];
    
    if (! [[self.params allKeys] containsObject:@"title"] || 0 >= [self.params[@"title"] length]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = RGBCOLOR(92.0f, 92.0f, 92.0f);
        label.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        [label sizeToFit];
        self.navigationItem.titleView = label;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // 如果是退出请求 http://segmentfault.com/user/logout ，拦截
    if ([@"segmentfault.com" isEqualToString:[request.URL host]]
        && [@"/user/logout" isEqualToString:[request.URL path]]) {
        return NO;
    }
    return YES;
}

#pragma mark

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (! [@"login" isEqualToString:[self.url host]]
        && 1 == [self.params[@"login"] intValue]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:SFNotificationLogout object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRequest) name:SFNotificationLogout object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UMNotificationWillShow object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyboard) name:UMNotificationWillShow object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = RGBCOLOR(92.0f, 92.0f, 92.0f);

    if ([[self.params allKeys] containsObject:@"title"] && 0 < [self.params[@"title"] length]) {
        label.text = self.params[@"title"];
    }
    else {
        label.text = @"Loading...";
    }
    [label sizeToFit];
    self.navigationItem.titleView = label;
}

@end
