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
    NSString*filePath=[[NSBundle mainBundle] pathForResource:@"QuestionDetail.js" ofType:@"txt"];
    NSString *js = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webView stringByEvaluatingJavaScriptFromString:js];
    self.webView.alpha = 1.0f;
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
