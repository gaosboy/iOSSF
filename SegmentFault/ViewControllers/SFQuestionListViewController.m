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
#import "SFQuestionListCell.h"

@interface SFQuestionListViewController ()
 <UITableViewDataSource, UITableViewDelegate, SRRefreshDelegate>

- (void)appendQuestions:(NSArray *)questions;
- (void)didLogout;

@property (assign, nonatomic)   BOOL                  hasMore;
@property (assign, nonatomic)   BOOL                  loading;
@property (strong, nonatomic)   NSString              *list;
@property (assign, nonatomic)   NSInteger             page;
@property (strong, nonatomic)   UITableView           *tableView;
@property (strong, nonatomic)   SRRefreshView         *slimeView;

@end

@implementation SFQuestionListViewController

#pragma mark - private

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

- (void)didLogout
{
    [self.questionList removeAllObjects];
    [self.tableView reloadData];
    [self.navigator popToRootViewControllerAnimated:NO];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFQuestionListCell *cell;
 
    if (indexPath.row < [self.questionList count]) {
        cell = [tableView questionListCell];
        [cell updateQuestionInfo:self.questionList[indexPath.row]];
    }
    else {
        cell = [tableView questionListLoadingCell];
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

    return (UITableViewCell *)cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.questionList count]) {
        CGFloat height = [SFTools heightOfString:self.questionList[indexPath.row][@"title"]
                                       withWidth:292.0f
                                            font:QUESTION_TITLE_LABEL_FONT];
        return height + 47.0f;
    }
    else {
        return 60.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigator openURL:[[NSURL URLWithString:@"sf://questiondetail"] addParams:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                     self.questionList[indexPath.row][@"id"], @"qid",
                                                                                     @"问题详情", @"title",
                                                                                     self.questionList[indexPath.row][@"title"], @"qtitle",
                                                                                     self.questionList[indexPath.row][@"answersWord"], @"answers",
                                                                                     nil]]
     withQuery:[NSDictionary dictionaryWithObjectsAndKeys:self.questionList[indexPath.row][@"tags"], @"tags" ,nil]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hasMore && 0 < [self.questionList count] ? [self.questionList count] + 1 : [self.questionList count];
}

#pragma mark - UIScrollViewDelegate

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
    if (! self.loading) {
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
}

#pragma mark

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.list = [[self.params allKeys] containsObject:@"list"] ? self.params[@"list"] : @"listnewest";
    if (nil == self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, self.view.height - 44.0f)
                                                      style:UITableViewStylePlain];
        
        self.tableView.backgroundColor = RGBCOLOR(244, 244, 244);
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        self.slimeView = [[SRRefreshView alloc] init];
        self.slimeView.delegate = self;
        self.slimeView.slimeMissWhenGoingBack = YES;
        self.slimeView.slime.bodyColor = RGBCOLOR(0, 154, 103); // 换成SF绿
        self.slimeView.slime.skinColor = RGBCOLOR(0, 154, 103); // 换成SF绿
        [self.tableView addSubview:_slimeView];
        
        [self.view addSubview:self.tableView];
    }
    
    self.page = 1;
    [self.slimeView setLoadingWithexpansion];
    [SFQuestionService getQuestionList:self.list onPage:self.page withBlock:^(NSArray *questions, NSError *error) {
        if (5 == error.code) {
            ;; // 没权限
        } else if (0 == error.code) {
            [self.questionList removeAllObjects];
            [self appendQuestions:questions];
        }
        [self.slimeView endRefresh];
    }];
    self.loading = YES;
    self.hasMore = YES;
}

@end
