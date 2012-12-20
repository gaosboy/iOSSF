//
//  UMViewController.m
//  URLManagerDemo
//
//  Created by jiajun on 8/6/12.
//  Copyright (c) 2012 jiajun. All rights reserved.
//

#define DEFAULT_SLIDE_VC_WIDTH      320.0f - 44.0f
#define SILENT_DISTANCE             40.0f
#define SILENT_DISTANCE_B           20.0f

#define ANIMATION_DURATION          0.3f

#import "UMViewController.h"

@interface UMViewController ()
@end

@implementation UMViewController

@synthesize url                     = _url;
@synthesize navigator               = _navigator;
@synthesize params                  = _params;
@synthesize query                   = _query;

#pragma mark - init

- (id)initWithURL:(NSURL *)aUrl
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.url = aUrl;
        self.params = [aUrl params];
    }
    return self;
}

- (id)initWithURL:(NSURL *)aUrl query:(NSDictionary *)aQuery {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.url = aUrl;
        self.params = [aUrl params];
        self.query = aQuery;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - before / after open

- (BOOL)shouldOpenViewControllerWithURL:(NSURL *)aUrl
{
    return YES;
}

- (void)openedFromViewControllerWithURL:(NSURL *)aUrl
{
}

@end
