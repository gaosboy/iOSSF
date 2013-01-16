//
//  SFQuestionDetailCell.h
//  SegmentFault
//
//  Created by jiajun on 1/11/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SFLocalWebView;

@interface SFQuestionDetailCell : UITableViewCell

@property (strong, nonatomic)   SFLocalWebView           *webView;

- (void)setDetailContent:(NSString *)content;

@end

@interface UITableView (SFQuestionDetailCell)

- (SFQuestionDetailCell *)questionDetailCell;

@end