//
//  SFLocalWebView.m
//  SegmentFault
//
//  Created by jiajun on 1/13/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import "SFLocalWebView.h"
#import "UMNavigationController.h"

@interface SFLocalWebView ()
<UIWebViewDelegate>

@end

@implementation SFLocalWebView

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString containsString:@"http://"]
        || [request.URL.absoluteString containsString:@"https://"]) {
        [self.navigator openURL:[[NSURL URLWithString:@"sf://webview"]
                                 addParams:[NSDictionary dictionaryWithObjectsAndKeys:
                                            request.URL.absoluteString, @"url",
                                            nil]]];
        return NO;
    }
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UIScrollView *scrollView = object;
    self.height = scrollView.contentSize.height;
    if (SFQuestionCellTypeQuestion == self.type) {
        [SFMessager addMessage:[NSString stringWithFormat:@"%f", self.height] forKey:QUESTION_DETAIL_HEIGHT];
        [[NSNotificationCenter defaultCenter] postNotificationName:SFNotificationQuestionLoaded object:nil];
    }
    else if (SFQuestionCellTypeAnswer == self.type) {
        [SFMessager addMessage:[NSString stringWithFormat:@"%f", self.height] forKey:ANSWER_DETAIL_HEIGHT];
        [[NSNotificationCenter defaultCenter] postNotificationName:SFNotificationAnswerLoaded object:nil];
    }
}

#pragma mark - super

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        self.multipleTouchEnabled = NO;
        self.autoresizesSubviews = YES;
        self.type = SFQuestionCellTypeAnswer;
        [(UIScrollView *)self.subviews[0] setShowsHorizontalScrollIndicator:NO];
        [(UIScrollView *)self.subviews[0] setShowsVerticalScrollIndicator:NO];
        [(UIScrollView *)self.subviews[0] setBounces:NO];
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        [self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

@end
