//
//  SFQuestionDetailViewController.m
//  SegmentFault
//
//  Created by jiajun on 12/12/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFLocalWebView.h"
#import "SFQuestionDetailViewController.h"
#import "SFQuestionService.h"
#import "SRRefreshView.h"

@interface SFQuestionDetailViewController ()
<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic)   SFLocalWebView              *answerView;
@property (strong, nonatomic)   UIActivityIndicatorView     *indicator;
@property (strong, nonatomic)   NSString                    *questionId;
@property (strong, nonatomic)   SFLocalWebView              *questionView;
@property (strong, nonatomic)   UITableView                 *tableView;

- (void)reloadData;

@end

@implementation SFQuestionDetailViewController

#pragma mark - private

- (void)reloadData
{
    if (nil == self.questionView) {
        self.questionView = [[SFLocalWebView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 44.0f)];
        NSString*filePath=[[NSBundle mainBundle] pathForResource:@"QuestionDetail.html" ofType:@"txt"];
        NSString *detailHTML = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [self.questionView loadHTMLString:[NSString stringWithFormat:detailHTML, [self.questionInfo objectForKey:@"question"]] baseURL:nil];
    }
    if (nil == self.answerView) {
        self.answerView = [[SFLocalWebView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 44.0f)];
        NSString*filePath=[[NSBundle mainBundle] pathForResource:@"AnswerDetail.html" ofType:@"txt"];
        NSString *detailHTML = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [self.answerView loadHTMLString:[NSString stringWithFormat:detailHTML, [self.questionInfo objectForKey:@"answers"]] baseURL:nil];
    }
    
    self.questionView.top = SECTION_HEADER_HEIGHT;
    [self.tableView addSubview:self.questionView];
    self.answerView.top = self.questionView.bottom + SECTION_HEADER_HEIGHT;
    [self.tableView addSubview:self.answerView];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *cellIndentifier = @"SFQuestoinDetailCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"question_detail_section_header_background.png"]];
    bg.frame = CGRectMake(0.0f, 0.0f, 320.0f, SECTION_HEADER_HEIGHT);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 300.0f, SECTION_HEADER_HEIGHT)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = RGBCOLOR(202.0f, 190.0f, 172.0f);
    if (0 == section) {
        label.font = [UIFont boldSystemFontOfSize:12.0f];
        label.numberOfLines = 0;
        label.text = ([[self.params allKeys] containsObject:@"qtitle"] && 0 < [[self.params objectForKey:@"qtitle"] length])
        ? [self.params objectForKey:@"qtitle"]
        : @"问题";
    }
    else if (1 == section) {
        label.font = [UIFont boldSystemFontOfSize:16.0f];
        label.text = [NSString stringWithFormat:@"答案（%@）", [self.params objectForKey:@"answers"]];
    }
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0.0f, -1.0f);
    [bg addSubview:label];
    return (UIView *)bg;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section && 0 == indexPath.row) {
        if (self.questionView && 0.0f < self.questionView.height) {
            return self.questionView.height + 10.0f;
        }
    }
    else if (1 == indexPath.section && 0 == indexPath.row) {
        if (self.answerView && 0.0f < self.answerView.height) {
            return self.answerView.height + 10.0f;
        }
    }
    
    return 54.0f;
}

#pragma mark

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (nil == self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.height -= 44.0f;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView];
    }
    
    if (nil == self.indicator) {
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicator.frame = CGRectMake(self.tableView.width / 2 - 20.0f, self.tableView.height / 2 - 60.0f, 40.0f, 40.0f);
        [self.view addSubview:self.indicator];
        [self.indicator startAnimating];
    }
    
    [SFQuestionService getQuestionDetailById:[self.params objectForKey:@"qid"] withBlock:^(NSDictionary *questionInfo, NSInteger answers, NSError *error){
        self.questionInfo = questionInfo;
        [self reloadData];
        [self.indicator removeFromSuperview];
        self.indicator = nil;
    }];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:SFNotificationAnswerLoaded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:SFNotificationAnswerLoaded object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SFNotificationQuestionLoaded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:SFNotificationQuestionLoaded object:nil];
}

@end
