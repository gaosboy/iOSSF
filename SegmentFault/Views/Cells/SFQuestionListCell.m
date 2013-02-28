//
//  SFQuestionListCell.m
//  SegmentFault
//
//  Created by jiajun on 2/28/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import "SFQuestionListCell.h"

@implementation UITableView (SFQuestionListTableView)

- (SFQuestionListCell *)questionListCell
{
    static NSString *CellIdentifier = @"SegmentFaultQuestionListCell";
    SFQuestionListCell *cell = (SFQuestionListCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[SFQuestionListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qlist_cell_selected_background.png"]];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        
        UILabel *answersLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 4.0f, 30.0f, 14.0f)];
        answersLabel.tag = 1000001;
        answersLabel.backgroundColor = [UIColor clearColor];
        answersLabel.textAlignment = NSTextAlignmentCenter;
        answersLabel.textColor = [UIColor whiteColor];
        answersLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [cell.imageView addSubview:answersLabel];
    }
        
    return cell;
}

- (SFQuestionListCell *)questionListLoadingCell
{
    static NSString *CellIdentifier = @"SegmentFaultQuestionLoadingCell";
    SFQuestionListCell *cell = (SFQuestionListCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SFQuestionListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"Loading ...";
        cell.textLabel.numberOfLines = 1;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [cell.imageView removeAllSubviews];
        cell.imageView.image = nil;
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

@end

@implementation SFQuestionListCell

- (void)updateQuestionInfo:(NSDictionary *)info
{
    if ([@"0" isEqualToString:info[@"answersWord"]]) {
        self.imageView.image = [UIImage imageNamed:@"qlist_cell_pop_unanswered.png"];
    }
    else {
        self.imageView.image = [UIImage imageNamed:@"qlist_cell_pop.png"];
    }
    
    __weak UILabel *answersLabel = (UILabel *)[self.imageView viewWithTag:1000001];
    answersLabel.text = info[@"answersWord"];
    self.textLabel.text = info[@"title"];
    self.detailTextLabel.text = info[@"createdDate"];
}

@end
