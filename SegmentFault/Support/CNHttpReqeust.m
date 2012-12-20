//
//  CNHttpReqeust.m
//  CoolName
//
//  Created by jiajun on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CNHttpReqeust.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@implementation CNHttpReqeust

@synthesize delegate;
@synthesize successCallback;
@synthesize failureCallback;
@synthesize completeCallback;
@synthesize responseDataType;

+ (void)invoke:(NSString *)url
		params:(NSMutableDictionary *)params
      userInfo:(NSMutableDictionary *)userInfo
	  delegate:(id)delegate 
	 onSuccess:(SEL)successCallback 
	 onFailure:(SEL)failureCallback 
	onComplete:(SEL)completeCallback
{
	CNHttpReqeust *request = [[CNHttpReqeust alloc] init];
	[request asynchronous:url params:params userInfo:userInfo delegate:delegate onSuccess:successCallback onFailure:failureCallback onComplete:completeCallback];
}

/**
 * 发起异步HTTP请求
 * params:专门用于存放上传参数的字典
 * userInfo:自定义字典,用于区分不同的请求,规定“_cacheType”字段用于存放缓存方案标识
 ASIDefaultCachePolicy = 0,
 ASIIgnoreCachePolicy = 1,
 ASIReloadIfDifferentCachePolicy = 2,
 ASIOnlyLoadIfNotCachedCachePolicy = 3,
 ASIUseCacheIfLoadFailsCachePolicy = 4
 分别用字符串:"0","1","2","3","4"表示
 *
 */
- (void)asynchronous:(NSString *)url
			  params:(NSMutableDictionary *)params
            userInfo:(NSMutableDictionary *)userInfo
			delegate:(id)aDelegate
		   onSuccess:(SEL)aSuccessCallback
		   onFailure:(SEL)aFailureCallback
		  onComplete:(SEL)aCompleteCallback
{
	self.delegate = aDelegate;
	self.successCallback = aSuccessCallback;
	self.failureCallback = aFailureCallback;
	self.completeCallback = aCompleteCallback;

	[self.delegate retain];
    
    self.responseDataType = [userInfo objectForKey:DATA_TYPE];
        
	if ([self.responseDataType isEqualToString:DATA_BYTE]) {
		if (nil != url && ![[NSNull null] isEqual:url ] && [url length] > 0 && [url hasPrefix:@"http://"]) {
            ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
            [request setRequestMethod:@"GET"];
            [request buildPostBody];
            [request setDelegate:self];
            [request startAsynchronous];
        }
	}
	else {
        if (params == nil) {
            params = [NSMutableDictionary dictionary];
        }
        
		ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[[NSURL URLWithString:url] addParams:params]];
		[request setRequestMethod:@"POST"];
		[request buildPostBody];
		[request setDelegate:self];
		[request startAsynchronous];
	}
}

/**
 * HTTP响应成功的回调函数
 *
 */
- (void)requestFinished:(ASIHTTPRequest*)request {
	NSError *error = [request error];
	if (!error) {
		int statusCode = [request responseStatusCode];
		if (statusCode == 200) {
			if ([DATA_BYTE isEqualToString:self.responseDataType]) {
				NSData *data = [request responseData];
				if ([self.delegate respondsToSelector:self.successCallback]) {
					[self.delegate performSelector:self.successCallback withObject:data withObject:request.originalURL.absoluteString];
				}
			}
			else {
                NSString *data = [request responseString];
                if (request.responseString && 0 < [request.responseString length]) {
                    if ([self.delegate respondsToSelector:self.successCallback]) {
                        [self.delegate performSelector:self.successCallback withObject:data];
                    }
                }
			}
		}
		else {
			NSString *statusMessage = [request responseStatusMessage];
			NSMutableDictionary *errorDic = [NSMutableDictionary dictionary];
			[errorDic setValue:statusMessage forKey:@"status"];
			NSError *httpError = [NSError errorWithDomain:@"HTTPResponseDomain"
													 code:statusCode
												 userInfo:errorDic];
			
			if ([self.delegate respondsToSelector:self.failureCallback]) {
				[self.delegate performSelector:self.failureCallback withObject:httpError];
			}
		}
	}
	else {
		if ([self.delegate respondsToSelector:self.failureCallback]) {
			[self.delegate performSelector:self.failureCallback withObject:error];
		}
	}
	
	if ([self.delegate respondsToSelector:self.completeCallback]) {
		[self.delegate performSelector:self.completeCallback];
	}
    [request release];
    [self release];
}

/**
 * HTTP响应失败的回调函数
 *
 */
- (void)requestFailed:(ASIHTTPRequest*)request {    
	NSError *error = [request error];

    if ([self.delegate respondsToSelector:self.failureCallback]) {
        [self.delegate performSelector:self.failureCallback withObject:error];
    }
    
    if ([self.delegate respondsToSelector:self.completeCallback]) {
        [self.delegate performSelector:self.completeCallback];
    }

    [request release];
    [self release];
}

@end
