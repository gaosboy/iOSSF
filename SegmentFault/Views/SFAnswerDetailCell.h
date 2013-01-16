//
//  SFAnswerDetailCell.h
//  SegmentFault
//
//  Created by jiajun on 1/16/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SFLocalWebView;

@interface SFAnswerDetailCell : UITableViewCell

@property (strong, nonatomic)   SFLocalWebView           *webView;

- (void)setDetailContent:(NSString *)content;

@end

@interface UITableView (SFAnswerDetailCell)

- (SFAnswerDetailCell *)answerDetailCell;

@end
