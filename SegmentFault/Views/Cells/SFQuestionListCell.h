//
//  SFQuestionListCell.h
//  SegmentFault
//
//  Created by jiajun on 2/28/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFQuestionListCell : UITableViewCell

- (void)updateQuestionInfo:(NSDictionary *)info;

@end

@interface UITableView (SFQuestionListTableView)

- (SFQuestionListCell *)questionListCell;
- (SFQuestionListCell *)questionListLoadingCell;

@end
