//
//  SFQuestionListViewController.m
//  SegmentFault
//
//  Created by jiajun on 11/29/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFQuestionListViewController.h"
#import "SFQuestionService.h"
#import "SRRefreshView.h"

@interface SFQuestionListViewController ()
 <UITableViewDataSource, UITableViewDelegate, SRRefreshDelegate>

@property (strong, nonatomic) UITableView           *tableView;
@property (strong, nonatomic) SRRefreshView         *slimeView;

@property (assign, nonatomic) BOOL                  hasMore;
@property (assign, nonatomic) BOOL                  loading;
@property (assign, nonatomic) NSInteger             page;
@property (strong, nonatomic) NSString              *list;

@end

@implementation SFQuestionListViewController

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    
    if (indexPath.row < [self.questionList count]) {
        CellIdentifier = @"SegmentFaultQuestionListCell";
    }else {
        CellIdentifier = @"SegmentFaultQuestionLoadingCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.row < [self.questionList count]) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            
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

        if ([@"0" isEqualToString:[[self.questionList objectAtIndex:indexPath.row] objectForKey:@"answersWord"]]) {
            cell.imageView.image = [UIImage imageNamed:@"qlist_cell_pop_unanswered.png"];
        }
        else {
            cell.imageView.image = [UIImage imageNamed:@"qlist_cell_pop.png"];
        }
        
        __weak UILabel *answersLabel = (UILabel *)[cell.imageView viewWithTag:1000001];
        answersLabel.text = [[self.questionList objectAtIndex:indexPath.row] objectForKey:@"answersWord"];
        cell.textLabel.text = [[self.questionList objectAtIndex:indexPath.row] objectForKey:@"title"];
        cell.detailTextLabel.text = [[self.questionList objectAtIndex:indexPath.row] objectForKey:@"createdDate"];
    }
    else {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor whiteColor];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"Loading ...";
            cell.textLabel.numberOfLines = 1;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
            [cell.imageView removeAllSubviews];
            cell.imageView.image = nil;
            cell.detailTextLabel.text = @"";
        }
        
        
        if (! self.loading && self.hasMore) {
            self.page ++;
            [SFQuestionService getQuestionList:self.list onPage:self.page withBlock:^(NSArray *questions, NSError *error) {
                if (5 == error.code) {
                    ;;
                } else if (0 == error.code) {
                    [self appendQuestions:questions];
                }
            }];
            self.loading = YES;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigator openURL:[[NSURL URLWithString:@"sf://questiondetail"] addParams:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                     [[self.questionList objectAtIndex:indexPath.row] objectForKey:@"id"], @"qid",
                                                                                     @"问题详情", @"title",
                                                                                     nil]]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hasMore && 0 < [self.questionList count] ? [self.questionList count] + 1 : [self.questionList count];
}

#pragma mark

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.list = [[self.params allKeys] containsObject:@"list"] ? [self.params objectForKey:@"list"] : @"listnewest";    
    if (nil == self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, self.view.height - 44.0f)
                                                      style:UITableViewStylePlain];
        
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.separatorColor = [UIColor lightGrayColor];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        self.slimeView = [[SRRefreshView alloc] init];
        self.slimeView.delegate = self;
        self.slimeView.slimeMissWhenGoingBack = YES;
        self.slimeView.slime.bodyColor = RGBCOLOR(0, 154, 103); // 换成SF绿
        [self.tableView addSubview:_slimeView];
        
        [self.view addSubview:self.tableView];
    }

    self.page = 1;
    [SFQuestionService getQuestionList:self.list onPage:self.page withBlock:^(NSArray *questions, NSError *error) {
        if (5 == error.code) {
            ;;
        } else if (0 == error.code) {
            [self.questionList removeAllObjects];
            [self appendQuestions:questions];
        }
    }];
    self.loading = YES;
    self.hasMore = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    self.page = 1;
    [SFQuestionService getQuestionList:self.list onPage:self.page withBlock:^(NSArray *questions, NSError *error) {
        [self.questionList removeAllObjects];
        if (5 == error.code) {
            ;;
        } else if (0 == error.code) {
            [self appendQuestions:questions];
        }
        [self.slimeView endRefresh];
    }];
}

// 把问题接在后边
- (void)appendQuestions:(NSArray *)questions
{
    self.hasMore = YES;
    if (nil != questions) {
        if (30 > [questions count]) {
            self.hasMore = NO;
        }
        if (nil == self.questionList) {
            self.questionList = [[NSMutableArray alloc] initWithArray:questions];
        }
        else {
            [self.questionList addObjectsFromArray:questions];
        }
    }
    self.loading = NO;
    [self.tableView reloadData];
}

- (void)clean
{
    [self.questionList removeAllObjects];
    [self.tableView reloadData];
    [self.navigator popToRootViewControllerAnimated:NO];
}

@end
