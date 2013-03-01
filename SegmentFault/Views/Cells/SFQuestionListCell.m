//
//  SFQuestionListCell.m
//  SegmentFault
//
//  Created by jiajun on 2/28/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import "SFQuestionListCell.h"
#import "SFLabel.h"

@implementation UITableView (SFQuestionListTableView)

- (SFQuestionListCell *)questionListCell
{
    static NSString *CellIdentifier = @"SegmentFaultQuestionListCell";
    SFQuestionListCell *cell = (SFQuestionListCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[SFQuestionListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = RGBCOLOR(244, 244, 244);
        
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qlist_cell_selected_background.png"]];
        
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];

        cell.detailTextLabel.numberOfLines = 1;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:24.0f];
        cell.detailTextLabel.text = @"　　　　　　　　　　　　";
        cell.detailTextLabel.textColor = [UIColor clearColor];
        
        SFLabel *answersLabel = [[SFLabel alloc] initWithFrame:CGRectMake(0.0f, 4.0f, 40.0f, 17.0f)
                                                     andInsets:UIEdgeInsetsMake(1.0f, 4.0f, 1.0f, 4.0f)];
        answersLabel.tag = QUESTION_LIST_CELL_ANSWER_LABEL;
        answersLabel.backgroundColor = RGBCOLOR(0, 154, 103);
        answersLabel.textAlignment = NSTextAlignmentCenter;
        answersLabel.textColor = [UIColor whiteColor];
        answersLabel.font = [UIFont systemFontOfSize:11.0f];
        answersLabel.layer.cornerRadius = 2.0f;
        [cell.detailTextLabel addSubview:answersLabel];
        
        UIView *tagsContainer = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 4.0f, 200.0f, 17.0f)];
        tagsContainer.tag = QUESTION_LIST_CELL_TAG_CONTAINER;
        tagsContainer.backgroundColor = RGBCOLOR(244, 244, 244);
        [cell.detailTextLabel addSubview:tagsContainer];
    }
        
    return cell;
}

- (SFQuestionListCell *)questionListLoadingCell
{
    static NSString *CellIdentifier = @"SegmentFaultQuestionLoadingCell";
    SFQuestionListCell *cell = (SFQuestionListCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SFQuestionListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = RGBCOLOR(244, 244, 244);
        
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

@interface SFQuestionListCell ()

@property (nonatomic, strong) NSMutableSet          *labelPool;

@end

@implementation SFQuestionListCell

- (void)updateQuestionInfo:(NSDictionary *)info
{
    __weak SFLabel *answersLabel = (SFLabel *)[self.detailTextLabel viewWithTag:QUESTION_LIST_CELL_ANSWER_LABEL];
    
    if ([@"0" isEqualToString:info[@"answersWord"]]) {
        answersLabel.backgroundColor = RGBCOLOR(159, 66, 69);
    }
    else {
        answersLabel.backgroundColor = RGBCOLOR(0, 154, 103);
    }
    if ([@"0" isEqualToString:info[@"answersWord"]] || [@"1" isEqualToString:info[@"answersWord"]]) {
        answersLabel.text = [NSString stringWithFormat:@"%@ answer", info[@"answersWord"]];
    }
    else {
        answersLabel.text = [NSString stringWithFormat:@"%@ answers", info[@"answersWord"]];
    }
    [answersLabel sizeToFit];

    __weak UIView *tagsContainer = [self.detailTextLabel viewWithTag:QUESTION_LIST_CELL_TAG_CONTAINER];
    tagsContainer.left = answersLabel.right + 2.0f;
    tagsContainer.width = 200.0f - tagsContainer.left;
    tagsContainer.backgroundColor = RGBCOLOR(244, 244, 244);
    for (UIView *tagLabel in tagsContainer.subviews) {
        [self.labelPool addObject:tagLabel];
        [tagLabel removeFromSuperview];
    }
    
    for (NSString *tag in (NSArray *)info[@"tags"]) {
        // 先到Pool里取，没有再新建
        SFLabel *label = (SFLabel *)[self.labelPool anyObject];
        if (nil == label) {
            label = [[SFLabel alloc] initWithInsets:UIEdgeInsetsMake(1.0f, 4.0f, 1.0f, 4.0f)];
            label.backgroundColor = RGBCOLOR(187, 187, 187);
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:11.0f];
            label.layer.cornerRadius = 2.0f;
        }
        else {
            [self.labelPool removeObject:label];
        }
        label.text = tag;
        [label sizeToFit];

        if (0 < [tagsContainer.subviews count]) {
            label.left = [(UIView *)tagsContainer.subviews.lastObject right] + 2.0f;
        }
        else {
            label.left = 0.0f;
        }
        // Label太长就跳过
        if (tagsContainer.right < label.right) {
            continue;
        }
        [tagsContainer addSubview:label];
    }
    self.textLabel.text = info[@"title"];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.labelPool = [[NSMutableSet alloc] init];
        return self;
    }
    return nil;
}

@end
