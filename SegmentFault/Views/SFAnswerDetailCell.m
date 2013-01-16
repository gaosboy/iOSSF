//
//  SFAnswerDetailCell.m
//  SegmentFault
//
//  Created by jiajun on 1/16/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import "SFAnswerDetailCell.h"
#import "SFLocalWebView.h"

@interface UITableViewCell ()
<UIWebViewDelegate>

@property (assign, nonatomic)   BOOL    loaded;

@end

@implementation UITableView (SFAnswerDetailCell)

- (SFAnswerDetailCell *)answerDetailCell
{
    static NSString *CellIdentifier = @"SegmentFaultAnswerDetailCell";
    SFAnswerDetailCell *cell = (SFAnswerDetailCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[SFAnswerDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = CGRectMake(140.0f, 10.0f, 40.0f, 40.0f);
        [cell.contentView addSubview:indicator];
        [indicator startAnimating];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

@end

@implementation SFAnswerDetailCell

@synthesize loaded              = _loaded;
@synthesize webView             = _webView;

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.clientHeight"] integerValue];
    webView.height = height;
//    self.loaded = YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString containsString:@"http://"]
        || [request.URL.absoluteString containsString:@"https://"]) {
        return NO;
    }
    return YES;
}

#pragma mark - public

- (void)setDetailContent:(NSString *)content
{
    if (! self.loaded) {
        NSString*filePath=[[NSBundle mainBundle] pathForResource:@"AnswerDetail.html" ofType:@"txt"];
        NSString *detailHTML = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        if (nil == self.webView) {
            self.loaded = NO;
            self.webView = [[SFLocalWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 44.0f)];
            self.webView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
            self.webView.multipleTouchEnabled = NO;
            self.webView.autoresizesSubviews = YES;
            self.webView.type = SFQuestionCellTypeAnswer;
            [(UIScrollView*)[self.webView.subviews objectAtIndex:0] setShowsHorizontalScrollIndicator:NO];
            [(UIScrollView*)[self.webView.subviews objectAtIndex:0] setShowsVerticalScrollIndicator:NO];
            [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];
            [self.webView loadHTMLString:[NSString stringWithFormat:detailHTML, content] baseURL:nil];
        }
        else {
            [self.webView loadHTMLString:[NSString stringWithFormat:detailHTML, content] baseURL:nil];
        }
        self.webView.frame = CGRectMake(10.0f, 5.0f, 300.0f, 100.0f);
        self.webView.delegate = self;
    }
    [self.contentView removeAllSubviews];
    [self.contentView addSubview:self.webView];
}

@end
