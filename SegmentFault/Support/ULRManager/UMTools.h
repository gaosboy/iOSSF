//
//  UMTools.h
//  URLManagerDemo
//
//  Created by jiajun on 8/8/12.
//  Copyright (c) 2012 jiajun. All rights reserved.
//

#define PROTOCOL        @"PROTOCOL"
#define HOST            @"HOST"
#define PARAMS          @"PARAMS"
#define URI             @"URI"

@interface NSURL (UMURL)

- (NSDictionary *)params;
- (NSString *)protocol;
- (NSURL *)addParams:(NSDictionary*)params;

@end

@interface NSString (UMString)

- (NSString *)urlencode;
- (NSString *)urldecode;

@end

@interface UIView (UMView)

- (CGFloat)left;
- (void)setLeft:(CGFloat)x;
- (CGFloat)top;
- (void)setTop:(CGFloat)y;
- (CGFloat)right;
- (void)setRight:(CGFloat)right;
- (CGFloat)bottom;
- (void)setBottom:(CGFloat)bottom;
- (CGFloat)centerX;
- (void)setCenterX:(CGFloat)centerX;
- (CGFloat)centerY;
- (void)setCenterY:(CGFloat)centerY;
- (CGFloat)width;
- (void)setWidth:(CGFloat)width;
- (CGFloat)height;
- (void)setHeight:(CGFloat)height;
- (CGPoint)origin;
- (void)setOrigin:(CGPoint)origin;
- (CGSize)size;
- (void)setSize:(CGSize)size;
- (void)removeAllSubviews;

@end