//
//  SFLocalWebView.h
//  SegmentFault
//
//  Created by jiajun on 1/13/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFQuestionDetailCell;

@interface SFLocalWebView : UIWebView

@property (assign, nonatomic)           SFQuestionCellType type;

@end
