//
//  UMTools.m
//  URLManagerDemo
//
//  Created by jiajun on 8/8/12.
//  Copyright (c) 2012 jiajun. All rights reserved.
//

#import "UMTools.h"

@implementation NSString (UMString)

- (NSString *)urldecode {
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlencode {
	NSString *encUrl = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	int len = [encUrl length];
	const char *c;
	c = [encUrl UTF8String];
	NSString *ret = @"";
	for(int i = 0; i < len; i++) {
		switch (*c) {
			case '/':
				ret = [ret stringByAppendingString:@"%2F"];
				break;
			case '\'':
				ret = [ret stringByAppendingString:@"%27"];
				break;
			case ';':
				ret = [ret stringByAppendingString:@"%3B"];
				break;
			case '?':
				ret = [ret stringByAppendingString:@"%3F"];
				break;
			case ':':
				ret = [ret stringByAppendingString:@"%3A"];
				break;
			case '@':
				ret = [ret stringByAppendingString:@"%40"];
				break;
			case '&':
				ret = [ret stringByAppendingString:@"%26"];
				break;
			case '=':
				ret = [ret stringByAppendingString:@"%3D"];
				break;
			case '+':
				ret = [ret stringByAppendingString:@"%2B"];
				break;
			case '$':
				ret = [ret stringByAppendingString:@"%24"];
				break;
			case ',':
				ret = [ret stringByAppendingString:@"%2C"];
				break;
			case '[':
				ret = [ret stringByAppendingString:@"%5B"];
				break;
			case ']':
				ret = [ret stringByAppendingString:@"%5D"];
				break;
			case '#':
				ret = [ret stringByAppendingString:@"%23"];
				break;
			case '!':
				ret = [ret stringByAppendingString:@"%21"];
				break;
			case '(':
				ret = [ret stringByAppendingString:@"%28"];
				break;
			case ')':
				ret = [ret stringByAppendingString:@"%29"];
				break;
			case '*':
				ret = [ret stringByAppendingString:@"%2A"];
				break;
			default:
				ret = [ret stringByAppendingFormat:@"%c", *c];
		}
		c++;
	}
    
	return ret;
}

@end

@implementation NSURL (UMSTRING)

- (NSDictionary *)params {
	NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
	if (NSNotFound != [self.absoluteString rangeOfString:@"?"].location) {
		NSString *paramString = [self.absoluteString substringFromIndex:([self.absoluteString rangeOfString:@"?"].location + 1)];
		NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&"];
		NSScanner* scanner = [[NSScanner alloc] initWithString:paramString];
		while (![scanner isAtEnd]) {
			NSString* pairString = nil;
			[scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
			[scanner scanCharactersFromSet:delimiterSet intoString:NULL];
			NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
			if (kvPair.count == 2) {
				NSString* key = [[kvPair objectAtIndex:0] urldecode];
				NSString* value = [[kvPair objectAtIndex:1] urldecode];
				[pairs setValue:value forKey:key];
			}
		}
	}
	
	return [NSDictionary dictionaryWithDictionary:pairs];
}

- (NSString *)protocol {
    if (NSNotFound != [self.absoluteString rangeOfString:@"://"].location) {
        return [self.absoluteString substringToIndex:([self.absoluteString rangeOfString:@"://"].location)];
    }
    return @"";
}

- (NSURL *)addParams:(NSDictionary *)params {
    NSMutableString *_add = nil;
    if (NSNotFound != [self.absoluteString rangeOfString:@"?"].location) {
        _add = [NSMutableString stringWithString:@"&"];
    }else {
        _add = [NSMutableString stringWithString:@"?"];
    }
    for (NSString* key in [params allKeys]) {
        if ([params objectForKey:key] && 0 < [[params objectForKey:key] length]) {
            [_add appendFormat:@"%@=%@&",key,[[params objectForKey:key] urlencode]];
        }
    }
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.absoluteString,[_add substringToIndex:[_add length] - 1]]];
}

@end

@implementation UIView (UMView)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = ceilf(x);
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = ceilf(y);
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = ceilf(right - frame.size.width);
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = ceilf(bottom - frame.size.height);
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(ceilf(centerX), self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, ceilf(centerY));
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = ceilf(width);
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = ceilf(height);
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)removeAllSubviews {
    for (__weak UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

@end