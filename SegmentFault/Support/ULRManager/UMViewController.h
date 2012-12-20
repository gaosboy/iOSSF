//
//  UMViewController.h
//  URLManagerDemo
//
//  Created by jiajun on 8/6/12.
//  Copyright (c) 2012 jiajun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UMTools.h"
#import "UMNavigationController.h"
#import "UMSlideNavigationController.h"

@interface UMViewController : UIViewController {
    NSString                *url;
}

- (id)initWithURL:(NSURL *)aUrl;
- (id)initWithURL:(NSURL *)aUrl query:(NSDictionary *)query;

- (BOOL)shouldOpenViewControllerWithURL:(NSURL *)aUrl;
- (void)openedFromViewControllerWithURL:(NSURL *)aUrl;

@property (strong, nonatomic) NSURL                         *url;
@property (strong, nonatomic) UMNavigationController        *navigator;
@property (strong, nonatomic) UMSlideNavigationController   *slideNavigator;

@property (strong, nonatomic) NSDictionary                  *params;
@property (strong, nonatomic) NSDictionary                  *query;

@end
