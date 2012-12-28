//
//  SFRootViewController.m
//  SegmentFault
//
//  Created by jiajun on 11/28/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFRootViewController.h"
#import "SFLoginService.h"

@interface SFRootViewController ()

// 用来记录将要打开的URL
@property (nonatomic, strong) NSURL *toOpen;

@end

@implementation SFRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (! [@"login" isEqualToString:[self.url host]]
        && 1 == [[self.params objectForKey:@"login"] intValue]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:SFNotificationLogout object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout) name:SFNotificationLogout object:nil];

    }

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = RGBCOLOR(92.0f, 92.0f, 92.0f);
    self.navigationItem.titleView = label;
    label.text = [self.params objectForKey:@"title"];
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
}

- (void)openedFromViewControllerWithURL:(NSURL *)aUrl
{
    UIButton *navBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [navBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navBtn setBackgroundImage:[UIImage imageNamed:@"back_button_background.png"] forState:UIControlStateNormal];
    [navBtn setBackgroundImage:[UIImage imageNamed:@"back_button_pressed_background.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:navBtn];
    self.navigationItem.leftBarButtonItem = btnItem;
}

- (BOOL)shouldOpenViewControllerWithURL:(NSURL *)aUrl
{
    if (! [@"login" isEqualToString:[aUrl host]]
        && 1 == [[aUrl.params objectForKey:@"login"] intValue]
        && ! [SFLoginService isLogin]) {
        self.toOpen = aUrl;
        [SFLoginService login:self withCallback:@"delayOpen"];
        return NO;
    }
    return YES;
}

// 登陆回调方法
- (void)delayOpen
{
    [self.navigator openURL:self.toOpen];
}

- (void)didLogout
{    
}

- (void)back
{
    [self.navigator popViewControllerAnimated:YES];
}

@end
