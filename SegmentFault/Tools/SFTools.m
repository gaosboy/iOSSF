//
//  SFTools.m
//  SegmentFault
//
//  Created by jiajun on 12/6/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFTools.h"
#import "SFAppDelegate.h"

@implementation SFTools

+ (NSString *)contentForFile:(NSString *)file ofType:(NSString *)type
{
    NSString*filePath=[[NSBundle mainBundle] pathForResource:file ofType:type];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return content;
}

+ (SFAppDelegate *)applicationDelegate
{
    return (SFAppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
