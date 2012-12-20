//
//  SFWebViewController.h
//  SegmentFault
//
//  Created by jiajun on 12/12/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFRootViewController.h"

@interface SFWebViewController : SFRootViewController <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView                 *webView;

- (void)loadRequest;
- (void)reloadToolBar;

@end