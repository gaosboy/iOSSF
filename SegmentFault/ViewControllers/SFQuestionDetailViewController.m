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
<UIScrollViewDelegate>

@property (strong, nonatomic)   UIImageView             *answerHeader;
@property (strong, nonatomic)   SFLocalWebView          *answerView;
@property (strong, nonatomic)   UIImageView             *questionHeader;
@property (strong, nonatomic)   NSString                *questionId;
@property (strong, nonatomic)   SFLocalWebView          *questionView;
@property (strong, nonatomic)   UIScrollView            *scrollView;

- (void)reloadData;

@end

@implementation SFQuestionDetailViewController

#pragma mark - private

- (void)reloadData
{
    if (nil == self.questionHeader) {
        self.questionHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"question_detail_section_header_background.png"]];
        self.questionHeader.frame = CGRectMake(0.0f, 0.0f, 320.0f, SECTION_HEADER_HEIGHT);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(6.0f, 3.0f, 320.0f, SECTION_HEADER_HEIGHT - 6.0f)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = RGBCOLOR(202.0f, 190.0f, 172.0f);
        label.font = [UIFont boldSystemFontOfSize:16.0f];
        label.text = @"问题";
        label.shadowColor = [UIColor blackColor];
        label.shadowOffset = CGSizeMake(0.0f, -1.0f);
        [self.questionHeader addSubview:label];

        [self.scrollView addSubview:self.questionHeader];
    }
    if (nil == self.questionView) {
        self.questionView = [[SFLocalWebView alloc] initWithFrame:CGRectMake(10.0f, self.questionHeader.bottom, 300.0f, 44.0f)];
        NSString*filePath=[[NSBundle mainBundle] pathForResource:@"QuestionDetail.html" ofType:@"txt"];
        NSString *detailHTML = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [self.questionView loadHTMLString:[NSString stringWithFormat:detailHTML, [self.questionInfo objectForKey:@"question"]] baseURL:nil];

        [self.scrollView addSubview:self.questionView];
    }

    if (nil == self.answerHeader) {
        self.answerHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"question_detail_section_header_background.png"]];
        self.answerHeader.frame = CGRectMake(0.0f, self.questionView.bottom, 320.0f, SECTION_HEADER_HEIGHT);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(6.0f, 3.0f, 320.0f, SECTION_HEADER_HEIGHT - 6.0f)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = RGBCOLOR(202.0f, 190.0f, 172.0f);
        label.font = [UIFont boldSystemFontOfSize:16.0f];
        label.text = [NSString stringWithFormat:@"答案（%@）", [self.params objectForKey:@"answers"]];
        label.shadowColor = [UIColor blackColor];
        label.shadowOffset = CGSizeMake(0.0f, -1.0f);
        [self.answerHeader addSubview:label];
        
        [self.scrollView addSubview:self.answerHeader];
    }
    if (nil == self.answerView) {
        self.answerView = [[SFLocalWebView alloc] initWithFrame:CGRectMake(10.0f, self.questionView.height + self.questionView.top + 5.0f, 300.0f, 44.0f)];
        NSString*filePath=[[NSBundle mainBundle] pathForResource:@"AnswerDetail.html" ofType:@"txt"];
        NSString *detailHTML = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [self.answerView loadHTMLString:[NSString stringWithFormat:detailHTML, [self.questionInfo objectForKey:@"answers"]] baseURL:nil];
        [self.scrollView addSubview:self.answerView];
    }
    
    [self.scrollView bringSubviewToFront:self.questionHeader];
    [self.scrollView bringSubviewToFront:self.answerHeader];
    
    self.answerHeader.top = self.questionView.bottom;
    self.answerView.top = self.answerHeader.bottom;
    self.scrollView.contentSize = CGSizeMake(320.0f, self.answerView.bottom + 5.0f);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (self.questionView.top < scrollView.contentOffset.y
//        && self.questionView.bottom > scrollView.contentOffset.y) {
//        self.questionHeader.top = scrollView.contentOffset.y;
//    }
}

#pragma mark

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (nil == self.scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.scrollView];
        self.scrollView.delegate = self;
    }
    
    [SFQuestionService getQuestionDetailById:[self.params objectForKey:@"qid"] withBlock:^(NSDictionary *questionInfo, NSInteger answers, NSError *error){
        self.questionInfo = questionInfo;
        [self reloadData];
    }];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:SFNotificationAnswerLoaded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:SFNotificationAnswerLoaded object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SFNotificationQuestionLoaded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:SFNotificationQuestionLoaded object:nil];
}

@end
