//
//  UMViewController.h
//  URLManagerDemo
//
//  Created by jiajun on 8/6/12.
//  Copyright (c) 2012 jiajun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMViewController;

@interface UMNavigationController : UINavigationController

- (void)openURL:(NSURL *)url withQuery:(NSDictionary *)query;
- (void)openURL:(NSURL *)url;
- (UMViewController *)viewControllerForURL:(NSURL *)url withQuery:(NSDictionary *)query;
- (BOOL)URLAvailable:(NSURL *)url;
- (id)initWithRootViewControllerURL:(NSURL *)url;

+ (void)setViewControllerName:(NSString *)className forURL:(NSString *)url;
+ (NSMutableDictionary *)config;

@property (strong, nonatomic) UMViewController *rootViewController;

@end
