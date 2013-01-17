//
//  SFLocalWebView.h
//  SegmentFault
//
//  Created by jiajun on 1/13/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMNavigationController;

@interface SFLocalWebView : UIWebView

@property (assign, nonatomic)               SFQuestionCellType      type;
@property (unsafe_unretained, nonatomic)    UMNavigationController  *navigator;

@end
