//
//  SFTools.h
//  SegmentFault
//
//  Created by jiajun on 12/6/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

@class SFAppDelegate;

@interface SFTools : NSObject

+ (NSString *)contentForFile:(NSString *)file ofType:(NSString *)type;
+ (SFAppDelegate *)applicationDelegate;

+ (float)heightOfString:(NSString *)string withWidth:(float)width font:(UIFont *)font;

@end
