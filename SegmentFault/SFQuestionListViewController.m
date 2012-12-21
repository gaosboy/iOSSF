//
//  SFQuestionListViewController.m
//  SegmentFault
//
//  Created by jiajun on 11/29/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFQuestionListViewController.h"
#import "SFQuestionService.h"

@interface SFQuestionListViewController ()

@property (strong, nonatomic) UITableView           *tableView;
@property (assign, nonatomic) BOOL                  hasMore;
@property (assign, nonatomic) BOOL                  loading;
@property (assign, nonatomic) NSInteger             page;

@end

@implementation SFQuestionListViewController

@synthesize tableView           = _tableView;
@synthesize questionList        = _questionList;

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
            
            cell.imageView.image = [UIImage imageNamed:@"qlist_cell_pop.png"];
            
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
            [SFQuestionService getNewestQuestionListPage:self.page withBlock:^(NSArray *questions, NSError *error) {
                [self appendQuestions:questions];
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
    return self.hasMore ? [self.questionList count] + 1 : [self.questionList count];
}

#pragma mark

- (id)initWithURL:(NSURL *)aUrl
{
    self = [super initWithURL:aUrl];
    if (self) {
        return self;
    }
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, self.view.height - 44.0f)
                                                  style:UITableViewStylePlain];

    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    self.questionList = [NSMutableArray array];
    self.page = 1;
    [SFQuestionService getNewestQuestionListPage:self.page withBlock:^(NSArray *questions, NSError *error) {
        [self appendQuestions:questions];
    }];
    self.loading = YES;
    self.hasMore = YES;
}

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

@end
