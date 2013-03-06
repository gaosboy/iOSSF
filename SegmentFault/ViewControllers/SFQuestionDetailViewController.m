//
//  SFQuestionDetailViewController.m
//  SegmentFault
//
//  Created by jiajun on 12/12/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFLabel.h"
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
@property (strong, nonatomic)   UIView                      *tagsContainer;
@property (strong, nonatomic)   SFLabel                     *titleLabel;

- (void)reloadData;

@end

@implementation SFQuestionDetailViewController

#pragma mark - private

- (void)reloadData
{
    if (nil == self.questionView) {
        self.questionView = [[SFLocalWebView alloc] initWithFrame:CGRectMake(10.0f, self.titleLabel.bottom, 300.0f, 44.0f)];
        self.questionView.navigator = self.navigator;
        NSString*filePath=[[NSBundle mainBundle] pathForResource:@"QuestionDetail.html" ofType:@"txt"];
        NSString *detailHTML = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [self.questionView loadHTMLString:[NSString stringWithFormat:detailHTML, self.questionInfo[@"question"]] baseURL:nil];
    }
    if (nil == self.answerView) {
        self.answerView = [[SFLocalWebView alloc] initWithFrame:CGRectMake(10.0f, self.questionView.bottom + SECTION_HEADER_HEIGHT, 300.0f, 44.0f)];
        self.answerView.navigator = self.navigator;
        NSString*filePath=[[NSBundle mainBundle] pathForResource:@"AnswerDetail.html" ofType:@"txt"];
        NSString *detailHTML = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [self.answerView loadHTMLString:[NSString stringWithFormat:detailHTML, self.questionInfo[@"answers"]] baseURL:nil];
    }
    
    self.questionView.top = self.titleLabel.bottom + 10.0f;
    [self.tableView insertSubview:self.questionView atIndex:2];
    self.answerView.top = self.questionView.bottom + SECTION_HEADER_HEIGHT;
    [self.tableView insertSubview:self.answerView atIndex:3];
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
    if (1 == section) {
        UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"question_list_header_bg.png"]];
        bg.frame = CGRectMake(0.0f, 0.0f, 320.0f, SECTION_HEADER_HEIGHT);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 300.0f, SECTION_HEADER_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = RGBCOLOR(44.0f, 44.0f, 44.0f);
        if (1 == section) {
            label.font = [UIFont boldSystemFontOfSize:15.0f];
            label.text = [NSString stringWithFormat:@"%@ 答案", self.params[@"answers"]];
        }
        label.shadowColor = [UIColor whiteColor];
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);

        [bg addSubview:label];
        return (UIView *)bg;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (1 == section) {
        return SECTION_HEADER_HEIGHT;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section && 0 == indexPath.row) {
        if (self.questionView && 0.0f < self.questionView.height) {
            return self.questionView.height + 20.0f + self.titleLabel.bottom;
        }
    }
    else if (1 == indexPath.section && 0 == indexPath.row) {
        if (self.answerView && 0.0f < self.answerView.height) {
            return self.answerView.height + 10.0f;
        }
    }
    
    return self.titleLabel.bottom + 10.0f;
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
    
    if (nil == self.tagsContainer) {
        self.tagsContainer = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 300.0f, 17.0f)];
        
        for (NSString *tag in (NSArray *)self.query[@"tags"]) {
            SFLabel *label = [[SFLabel alloc] initWithInsets:UIEdgeInsetsMake(1.0f, 4.0f, 1.0f, 4.0f)];
            label.backgroundColor = RGBCOLOR(187, 187, 187);
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.font = TAG_LABEL_FONT;
            label.layer.cornerRadius = 2.0f;
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
        
        [self.tableView addSubview:self.tagsContainer];
    }
    
    if (nil == self.titleLabel) {
        self.titleLabel = [[SFLabel alloc] initWithFrame:CGRectMake(10.0f, self.tagsContainer.bottom + 14.0f, 300.0f, 17.0f)];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = QUESTION_TITLE_LABEL_FONT;
        self.titleLabel.text = self.params[@"qtitle"];
        self.titleLabel.height = [SFTools heightOfString:self.titleLabel.text
                                               withWidth:292.0f
                                                    font:QUESTION_TITLE_LABEL_FONT];
        [self.tableView addSubview:self.titleLabel];
    }
    
    [SFQuestionService getQuestionDetailById:self.params[@"qid"] withBlock:^(NSDictionary *questionInfo, NSInteger answers, NSError *error){
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
