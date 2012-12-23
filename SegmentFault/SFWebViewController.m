//
//  SFWebViewController.m
//  SegmentFault
//
//  Created by jiajun on 12/12/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFWebViewController.h"

@interface SFWebViewController ()

@end

@implementation SFWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
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

- (void)back
{
    [self.navigator popViewControllerAnimated:YES];
}

@end
