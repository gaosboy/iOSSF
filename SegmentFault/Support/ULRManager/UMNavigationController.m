//
//  UMViewController.m
//  URLManagerDemo
//
//  Created by jiajun on 8/6/12.
//  Copyright (c) 2012 jiajun. All rights reserved.
//

#import "UMNavigationController.h"
#import "UMViewController.h"

@interface UMNavigationController ()
@end

@implementation UMNavigationController

@synthesize config          = _config;

#pragma mark - init

- (id)initWithRootViewController:(UMViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.config = [[NSMutableDictionary alloc] init];
        rootViewController.navigator = self;
    }
    return self;
}

#pragma mark - actions

- (UMViewController *)viewControllerForURL:(NSURL *)url withQuery:(NSDictionary *)query
{
    NSString *urlString = [NSString stringWithFormat:@"%@://%@", [url scheme], [url host]];
    UMViewController * viewController = nil;

    if ([self URLAvailable:url]) {
        Class class = NSClassFromString([self.config objectForKey:urlString]);
        
        if (nil == query) {
            viewController = (UMViewController *)[[class alloc] initWithURL:url];
        }
        else {
            viewController = (UMViewController *)[[class alloc] initWithURL:url query:query];
        }
        viewController.navigator = self;
    }
    
    return viewController;
}

- (BOOL)URLAvailable:(NSURL *)url
{
    NSString *urlString = [NSString stringWithFormat:@"%@://%@", [url scheme], [url host]];
    return [[self.config allKeys] containsObject:urlString];
}

- (void)openURL:(NSURL *)url
{
    [self openURL:url withQuery:nil];
}

- (void)openURL:(NSURL *)url withQuery:(NSDictionary *)query
{
    UMViewController *lastViewController = (UMViewController *)[self.viewControllers lastObject];
    UMViewController *viewController = [self viewControllerForURL:url withQuery:query];
    if ([lastViewController shouldOpenViewControllerWithURL:url]) {
        [self pushViewController:viewController animated:YES];
        [viewController openedFromViewControllerWithURL:lastViewController.url];
    }
}

#pragma mark - config

- (void)setViewControllerName:(NSString *)className forURL:(NSString *)url
{
    if (nil == self.config) {
        self.config = [[NSMutableDictionary alloc] init];
    }
    
    [self.config setValue:className forKey:url];
}

@end
