//
//  SFAppDelegate.m
//  SegmentFault
//
//  Created by jiajun on 11/24/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFAppDelegate.h"

#import "SFMainViewController.h"
#import "SFSlideNavViewController.h"
#import "SFQuestionListViewController.h"
#import "SFLoginViewController.h"
#import "UMNavigationController.h"

#define NAVIGATION_BAR_BTN_RECT         CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)

@implementation SFAppDelegate

@synthesize navigator                       = _navigator;

@synthesize newestVC                        = _newestVC;
@synthesize newestNavigator                 = _newestNavigator;

@synthesize hottestVC                       = _hottestVC;
@synthesize hottestNavigator                = _hottestNavigator;

@synthesize followedQuestionsVC             = _followedQuestionsVC;
@synthesize followedQuestionsNavigator      = _followedQuestionsNavigator;

@synthesize userSettingsVC                  = _followedTagsVC;
@synthesize userSettingsNavigator           = _followedTagsNavigator;

@synthesize window                          = _window;
@synthesize config                          = _config;

- (void)initURLMapping
{
    self.config = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                   @"SFMainViewController", @"sf://main",
                   @"SFQuestionListViewController", @"sf://questionlist",
                   @"SFQuestionDetailViewController", @"sf://questiondetail",
                   @"SFWebViewController", @"http://segmentfault.com",
                   @"SFWebViewController", @"sf://webview",
                   nil];
}

- (void)initSlideNavigator
{
    self.navigator = [[SFSlideNavViewController alloc] initWithItems:@[@[self.newestNavigator, self.hottestNavigator],
                      @[self.followedQuestionsNavigator, self.userSettingsNavigator]]];
    
}

- (void)initViewControllers
{
    UIButton *nNavBtn = [[UIButton alloc] initWithFrame:NAVIGATION_BAR_BTN_RECT];
    [nNavBtn setBackgroundImage:[UIImage imageNamed:@"slide_navigator_button.png"] forState:UIControlStateNormal];
    [nNavBtn setBackgroundImage:[UIImage imageNamed:@"slide_navigator_button_pressed.png"] forState:UIControlStateHighlighted];
    [nNavBtn addTarget:self.navigator action:@selector(slideButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nBtnItem = [[UIBarButtonItem alloc] initWithCustomView:nNavBtn];
    self.newestVC = [[SFQuestionListViewController alloc] initWithURL:[[NSURL URLWithString:@"sf://questionlist"]
                                                                       addParams:[NSDictionary dictionaryWithObjectsAndKeys:@"最新问题", @"title", nil]]];
    self.newestVC.navigationItem.leftBarButtonItem = nBtnItem;
    
    UIButton *hNavBtn = [[UIButton alloc] initWithFrame:NAVIGATION_BAR_BTN_RECT];
    [hNavBtn setBackgroundImage:[UIImage imageNamed:@"slide_navigator_button.png"] forState:UIControlStateNormal];
    [hNavBtn setBackgroundImage:[UIImage imageNamed:@"slide_navigator_button_pressed.png"] forState:UIControlStateHighlighted];
    [hNavBtn addTarget:self.navigator action:@selector(slideButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *hBtnItem = [[UIBarButtonItem alloc] initWithCustomView:hNavBtn];
    self.hottestVC = [[SFMainViewController alloc] initWithURL:[[NSURL URLWithString:@"sf://main"]
                                                                addParams:[NSDictionary dictionaryWithObjectsAndKeys:@"最新问题", @"title", nil]]];
    self.hottestVC.navigationItem.leftBarButtonItem = hBtnItem;
    
    UIButton *fQNavBtn = [[UIButton alloc] initWithFrame:NAVIGATION_BAR_BTN_RECT];
    [fQNavBtn setBackgroundImage:[UIImage imageNamed:@"slide_navigator_button.png"] forState:UIControlStateNormal];
    [fQNavBtn setBackgroundImage:[UIImage imageNamed:@"slide_navigator_button_pressed.png"] forState:UIControlStateHighlighted];
    [fQNavBtn addTarget:self.navigator action:@selector(slideButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fQBtnItem = [[UIBarButtonItem alloc] initWithCustomView:fQNavBtn];
    self.followedQuestionsVC = [[SFMainViewController alloc] initWithURL:[[NSURL URLWithString:@"sf://main"]
                                                                          addParams:[NSDictionary dictionaryWithObjectsAndKeys:@"最新问题", @"title", nil]]];
    self.followedQuestionsVC.navigationItem.leftBarButtonItem = fQBtnItem;
    
    UIButton *fTNavBtn = [[UIButton alloc] initWithFrame:NAVIGATION_BAR_BTN_RECT];
    [fTNavBtn setBackgroundImage:[UIImage imageNamed:@"slide_navigator_button.png"] forState:UIControlStateNormal];
    [fTNavBtn setBackgroundImage:[UIImage imageNamed:@"slide_navigator_button_pressed.png"] forState:UIControlStateHighlighted];
    [fTNavBtn addTarget:self.navigator action:@selector(slideButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fTBtnItem = [[UIBarButtonItem alloc] initWithCustomView:fTNavBtn];
    self.userSettingsVC = [[SFLoginViewController alloc] initWithURL:[[NSURL URLWithString:@"http://segmentfault.com/user/settings"]
                                                                             addParams:[NSDictionary dictionaryWithObjectsAndKeys:@"个人资料", @"title", nil]]];
    self.userSettingsVC.navigationItem.leftBarButtonItem = fTBtnItem;
}

- (void)initNavigators
{
    self.newestNavigator = [[UMNavigationController alloc] initWithRootViewController:self.newestVC];
    self.newestNavigator.config = self.config;
    [self.newestNavigator.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_light_background.png"] forBarMetrics:UIBarMetricsDefault];
    self.newestNavigator.title = @"最新问题";
    
    self.hottestNavigator = [[UMNavigationController alloc] initWithRootViewController:self.hottestVC];
    self.hottestNavigator.config = self.config;
    [self.hottestNavigator.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_light_background.png"] forBarMetrics:UIBarMetricsDefault];
    self.hottestNavigator.title = @"热门问题";
    
    self.followedQuestionsNavigator = [[UMNavigationController alloc] initWithRootViewController:self.followedQuestionsVC];
    self.followedQuestionsNavigator.config = self.config;
    [self.followedQuestionsNavigator.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_light_background.png"] forBarMetrics:UIBarMetricsDefault];
    self.followedQuestionsNavigator.title = @"关注的问题";
    
    self.userSettingsNavigator = [[UMNavigationController alloc] initWithRootViewController:self.userSettingsVC];
    self.userSettingsNavigator.config = self.config;
    [self.userSettingsNavigator.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_light_background.png"] forBarMetrics:UIBarMetricsDefault];
    self.userSettingsNavigator.title = @"个人资料";
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    [self initURLMapping];
    [self initViewControllers];
    [self initNavigators];
    [self initSlideNavigator];

    [self.window addSubview:self.navigator.view];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
