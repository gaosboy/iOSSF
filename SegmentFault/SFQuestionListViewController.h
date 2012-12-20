//
//  SFQuestionListViewController.h
//  SegmentFault
//
//  Created by jiajun on 11/29/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFRootViewController.h"

@interface SFQuestionListViewController : SFRootViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray            *questionList;

@end
