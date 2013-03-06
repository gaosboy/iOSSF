//
//  SFQuestionListCell.m
//  SegmentFault
//
//  Created by jiajun on 2/28/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import "SFQuestionListCell.h"
#import "SFLabel.h"

@interface SFQuestionListCell ()

@property (nonatomic, strong) SFLabel               *answersLabel;
@property (nonatomic, strong) UIImageView           *cellSeparator;
@property (nonatomic, strong) NSMutableSet          *labelPool;
@property (nonatomic, strong) UIView                *tagsContainer;
@property (nonatomic, strong) SFLabel               *titleLabel;
@property (nonatomic, strong) UIImageView           *voteIcon;
@property (nonatomic, strong) SFLabel               *voteNumber;

@end

@implementation SFQuestionListCell

- (void)updateQuestionInfo:(NSDictionary *)info
{
    self.titleLabel.text = info[@"title"];
    self.titleLabel.height = [SFTools heightOfString:self.titleLabel.text
                                           withWidth:292.0f
                                                font:QUESTION_TITLE_LABEL_FONT];

    if ([@"0" isEqualToString:info[@"answersWord"]]) {
        self.answersLabel.backgroundColor = RGBCOLOR(159, 66, 69);
    }
    else {
        self.answersLabel.backgroundColor = RGBCOLOR(0, 154, 103);
    }
    self.answersLabel.text = [NSString stringWithFormat:@"%@ answer", info[@"answersWord"]];
    [self.answersLabel sizeToFit];
    self.answersLabel.top = self.titleLabel.bottom + 5.0f;
    
    self.tagsContainer.top = self.answersLabel.top;
    self.tagsContainer.left = self.answersLabel.right + 2.0f;
    self.tagsContainer.width = 240.0f - self.tagsContainer.left;
    for (UIView *tagLabel in self.tagsContainer.subviews) {
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
            label.font = TAG_LABEL_FONT;
            label.layer.cornerRadius = 2.0f;
        }
        else {
            [self.labelPool removeObject:label];
        }
        label.text = tag;
        [label sizeToFit];
        
        if (0 < [self.tagsContainer.subviews count]) {
            label.left = [(UIView *)self.tagsContainer.subviews.lastObject right] + 2.0f;
        }
        else {
            label.left = 0.0f;
        }
        // Label太长就跳过
        if (self.tagsContainer.width < label.right) {
            continue;
        }
        [self.tagsContainer addSubview:label];
    }

    self.voteIcon.top = self.titleLabel.bottom + 10.0f;

    self.voteNumber.text = info[@"votes"];
    [self.voteNumber sizeToFit];
    self.voteNumber.top = self.voteIcon.top - 2.0f;
    
    self.cellSeparator.top = self.tagsContainer.bottom + 10.0f;
}

@end

@implementation UITableView (SFQuestionListTableView)

- (SFQuestionListCell *)questionListCell
{
    static NSString *CellIdentifier = @"SegmentFaultQuestionListCell";
    SFQuestionListCell *cell = (SFQuestionListCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[SFQuestionListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = RGBCOLOR(244, 244, 244);
        
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qlist_cell_selected_background.png"]];

        cell.labelPool = [[NSMutableSet alloc] init];

        cell.titleLabel = [[SFLabel alloc] initWithFrame:CGRectMake(14.0f, 12.0f, 292.0f, 15.0f)];
        cell.titleLabel.numberOfLines = 0;
        cell.titleLabel.font = QUESTION_TITLE_LABEL_FONT;
        cell.titleLabel.backgroundColor = RGBCOLOR(244, 244, 244);
        [cell.contentView addSubview:cell.titleLabel];
        
        cell.answersLabel = [[SFLabel alloc] initWithFrame:CGRectMake(14.0f, 4.0f, 40.0f, 17.0f)
                                                     andInsets:UIEdgeInsetsMake(1.0f, 4.0f, 1.0f, 4.0f)];
        cell.answersLabel.backgroundColor = RGBCOLOR(0, 154, 103);
        cell.answersLabel.textAlignment = NSTextAlignmentCenter;
        cell.answersLabel.textColor = [UIColor whiteColor];
        cell.answersLabel.font = TAG_LABEL_FONT;
        cell.answersLabel.layer.cornerRadius = 2.0f;
        [cell.contentView addSubview:cell.answersLabel];

        cell.tagsContainer = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 4.0f, 200.0f, 17.0f)];
        cell.tagsContainer.backgroundColor = RGBCOLOR(244, 244, 244);
        [cell.contentView addSubview:cell.tagsContainer];
        
        cell.voteIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"question_list_vote.png"]];
        cell.voteIcon.left = 270.0f;
        cell.voteIcon.top = cell.answersLabel.top + 2.0f;
        [cell.contentView addSubview:cell.voteIcon];
        
        cell.voteNumber = [[SFLabel alloc] initWithFrame:CGRectMake(cell.voteIcon.right + 5.0f, cell.voteIcon.top, 2.0f, 2.0f)];
        cell.voteNumber.backgroundColor = RGBCOLOR(244, 244, 244);
        cell.voteNumber.textColor = RGBCOLOR(153.0f, 153.0f, 153.0f);
        cell.voteNumber.font = [UIFont systemFontOfSize:14.0f];
        [cell.contentView addSubview:cell.voteNumber];
        
        cell.cellSeparator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"question_list_cell_sep.png"]];
        [cell.contentView addSubview:cell.cellSeparator];
    }
        
    return cell;
}

- (SFQuestionListCell *)questionListLoadingCell
{
    static NSString *CellIdentifier = @"SegmentFaultQuestionLoadingCell";
    SFQuestionListCell *cell = (SFQuestionListCell *)[self dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SFQuestionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = RGBCOLOR(244, 244, 244);
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"Loading ...";
        cell.textLabel.numberOfLines = 1;
        cell.textLabel.font = QUESTION_TITLE_LABEL_FONT;
    }
    return cell;
}

@end
