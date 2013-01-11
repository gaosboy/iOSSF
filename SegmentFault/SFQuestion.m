//
//  SFQuestion.m
//  SegmentFault
//
//  Created by jiajun on 12/14/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFQuestion.h"
#import "AFJSONRequestOperation.h"

@interface SFQuestionHttpClient ()

@end

@implementation SFQuestionHttpClient

+ (SFQuestionHttpClient *)sharedClient
{
    static SFQuestionHttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[SFQuestionHttpClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://segmentfault.com/"]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

@end

@interface SFQuestion ()

<UIWebViewDelegate>

@property (copy, nonatomic)     SFQuestionDetailLoadedBlock     detailLoadedBlock;
@property (strong, nonatomic)   NSString                        *questionId;
@property (strong, nonatomic)   UIWebView                       *webView;

- (void)load;

@end

@implementation SFQuestion

#pragma mark - private

- (void)load
{
    [self.webView stopLoading];
    NSString *url = [NSString stringWithFormat:@"http://segmentfault.com/q/%@", self.questionId];
    url = @"http://baidu.com";
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:requestObj];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSString *js = [NSString stringWithFormat:@"document.getElementById('q-%@')", self.questionId];
    NSString *js = @"document.getElementById('lg')";
    NSString *pageSource = [webView stringByEvaluatingJavaScriptFromString:js];
    NSLog(@"pagesource:%@", pageSource);
    NSDictionary *questionInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"22", @"11", nil];
    NSInteger answers = 1;
    if (self.detailLoadedBlock) {
        self.detailLoadedBlock(questionInfo, answers, [NSError errorWithDomain:@".segmentfault.com" code:200 userInfo:nil]);
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"start load");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (self.detailLoadedBlock) {
        self.detailLoadedBlock(nil, 0, error);
    }
}

#pragma mark - parent

- (id)init
{
    self = [super init];
    if (self) {
        self.webView = [[UIWebView alloc] init];
        self.webView.delegate = self;
        
        return self;
    }
    return nil;
}

#pragma mark - static

+ (void)questionDetailBy:(NSString *)qid
               withBlock:(SFQuestionDetailLoadedBlock)block
{
    static SFQuestion *obj = nil;
    if (nil == obj) {
        obj = [[SFQuestion alloc] init];
    }
    obj.questionId = qid;
    obj.detailLoadedBlock = block;
    [obj load];
}

+ (void)questionListByPath:(NSString *)path
                         onPage:(NSInteger)page size:(NSInteger)size
                      withBlock:(SFQuestionListLoadedBlock)block
{
    // From Internet
    [[SFQuestionHttpClient sharedClient] getPath:path parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                             [NSString stringWithFormat:@"%d", page], @"page",
                                                                             [NSString stringWithFormat:@"%d", size], @"size",
                                                                             nil]
                                         success:^(AFHTTPRequestOperation *operation, id JSON) {
                                             NSDictionary *data = [JSON valueForKeyPath:@"data"];
                                             NSInteger status = [[JSON valueForKeyPath:@"status"] intValue];
                                             if (block) {
                                                 block([data objectForKey:@"items"], [NSError errorWithDomain:@".segmentfault.com" code:status userInfo:nil]);
                                             }
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             if (block) {
                                                 block(nil, error);
                                             }
                                         }];
}

@end
