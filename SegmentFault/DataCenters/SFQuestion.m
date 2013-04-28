//
//  SFQuestion.m
//  SegmentFault
//
//  Created by jiajun on 12/14/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "AFJSONRequestOperation.h"
#import "KCH.h"
#import "SFQuestion.h"
#import "GTMNSString+HTML.h"

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
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:requestObj];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *questionJS = [NSString stringWithFormat:[SFTools contentForFile:@"GetQuestionDetail.js" ofType:@"txt"], self.questionId];
    NSString *question = [webView stringByEvaluatingJavaScriptFromString:questionJS];
    [webView stringByEvaluatingJavaScriptFromString:[SFTools contentForFile:@"AnswerDetail.js" ofType:@"txt"]];
    NSString *answerJS = [SFTools contentForFile:@"GetQuestionAnswer.js" ofType:@"txt"];
    NSString *answer = [webView stringByEvaluatingJavaScriptFromString:answerJS];
    
    NSDictionary *questionInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  question, @"question",
                                  answer, @"answers",
                                  nil];
    
    [Kache setValue:questionInfo
             forKey:SFQuestionDetailCacheKey(self.questionId)
       expiredAfter:5];

    if (self.detailLoadedBlock) {
        self.detailLoadedBlock(questionInfo, 0, [NSError errorWithDomain:@".segmentfault.com" code:200 userInfo:nil]);
    }
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
    NSDictionary *questionInfo = [Kache valueForKey:SFQuestionDetailCacheKey(qid)];
    if (questionInfo) {
        block(questionInfo, 0, [NSError errorWithDomain:@".segmentfault.com" code:200 userInfo:nil]);
    }
    else {
        static SFQuestion *obj = nil;
        if (nil == obj) {
            obj = [[SFQuestion alloc] init];
        }
        obj.questionId = qid;
        obj.detailLoadedBlock = block;
        [obj load];
    }
}

+ (NSDictionary *)parseItem:(NSDictionary *)item {
    NSMutableDictionary * parsedItem = [item mutableCopy];
    NSString * originTitle = parsedItem[@"title"];
    NSLog(@"title = %@", originTitle);
    if ([originTitle isKindOfClass:[NSString class]]) {
        parsedItem[@"title"] = [originTitle gtm_stringByUnescapingFromHTML];
        return parsedItem;
    } else {
        return item;
    }
}

+ (NSDictionary *)parseData:(NSDictionary *)data {
    NSMutableDictionary * parsedData = [data mutableCopy];
    NSMutableArray * items = [parsedData[@"items"] mutableCopy];
    for (int i = 0; i < items.count; ++i) {
        NSDictionary * item = items[i];
        items[i] = [self parseItem:item];
    }
    parsedData[@"items"] = items;
    return parsedData;
    
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
                                             data = [self parseData:data];
                                             NSInteger status = [[JSON valueForKeyPath:@"status"] intValue];
                                             if (block) {
                                                 block(data[@"items"], [NSError errorWithDomain:@".segmentfault.com" code:status userInfo:nil]);
                                             }
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             if (block) {
                                                 block(nil, error);
                                             }
                                         }];
}

@end
