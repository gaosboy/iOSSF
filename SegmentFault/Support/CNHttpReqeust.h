//
//  CNHttpReqeust.h
//  CoolName
//
//  Created by jiajun on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define DATA_TYPE		@"_dataType"

// 返回字节类型,用于图片下载
#define DATA_BYTE		@"byte"
// 返回字符串类型,用于推请求
#define DATA_STRING		@"string"

#import <Foundation/Foundation.h>

@interface CNHttpReqeust : NSObject

+ (void)invoke:(NSString *)url
		params:(NSMutableDictionary *)params
      userInfo:(NSMutableDictionary *)userInfo
	  delegate:(id)delegate 
	 onSuccess:(SEL)successCallback 
	 onFailure:(SEL)failureCallback 
	onComplete:(SEL)completeCallback;

- (void)asynchronous:(NSString *)url
			  params:(NSMutableDictionary *)params
            userInfo:(NSMutableDictionary *)userInfo
			delegate:(id)delegate
		   onSuccess:(SEL)successCallback
		   onFailure:(SEL)failureCallback
		  onComplete:(SEL)completeCallback;

@property (nonatomic, assign)   id delegate;
@property (nonatomic, assign)   SEL successCallback;
@property (nonatomic, assign)   SEL failureCallback;
@property (nonatomic, assign)   SEL completeCallback;
@property (nonatomic, copy)     NSString *responseDataType;

@end
